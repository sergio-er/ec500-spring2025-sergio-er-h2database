package org.h2.command.query;

import org.h2.engine.SessionLocal;
import org.h2.table.TableFilter;
import org.h2.expression.Expression;
import org.h2.expression.ExpressionColumn;
import org.h2.expression.condition.Comparison;
import org.h2.expression.condition.ConditionAndOr;
import java.util.*;


/**
 * Determines the best join order by following rules rather than considering every possible permutation.
 */
public class RuleBasedJoinOrderPicker {
    final SessionLocal session;
    final TableFilter[] filters;

    public RuleBasedJoinOrderPicker(SessionLocal session, TableFilter[] filters) {
        this.session = session;
        this.filters = filters;
    }

    public TableFilter[] bestOrder() {
        // Step 1: Extract all explicit joins
        Set<String> joinPairs = new HashSet<>();
        Expression fullCondition = filters[0].getFullCondition();
        collectJoinPairs(fullCondition, joinPairs);

//         Step 2: Start with smallest table
        List<TableFilter> remaining = new ArrayList<>(Arrays.asList(filters));
        List<TableFilter> ordered = new ArrayList<>();

        TableFilter first = findSmallest(remaining);
        ordered.add(first);
        remaining.remove(first);

        // Step 3: Iteratively add smallest valid joined table
        while (!remaining.isEmpty()) {
            TableFilter next = null;
            long minRows = Long.MAX_VALUE;

            for (TableFilter candidate : remaining) {
                if (hasJoinWithAny(candidate, ordered, joinPairs)) {
                    long rows = candidate.getTable().getRowCountApproximation(session);
                    if (rows < minRows) {
                        minRows = rows;
                        next = candidate;
                    }
                }
            }

            if (next == null) {
                throw new RuntimeException("No valid join found without introducing a cartesian product.");
            }

            ordered.add(next);
            remaining.remove(next);
        }

        return ordered.toArray(new TableFilter[0]);
    }

    // Extracts all pairs of table aliases that have a join condition
    private void collectJoinPairs(Expression expr, Set<String> result) {
        if (expr == null) return;

        if (expr instanceof ConditionAndOr || expr instanceof Comparison) {
            Expression left = expr.getSubexpression(0);
            Expression right = expr.getSubexpression(1);

            collectJoinPairs(left, result);
            collectJoinPairs(right, result);

            if (expr instanceof Comparison) {
                String leftAlias = extractTableAlias(left);
                String rightAlias = extractTableAlias(right);

                if (leftAlias != null && rightAlias != null && !leftAlias.equals(rightAlias)) {
                    result.add(makeKey(leftAlias, rightAlias));
                }
            }
        }
    }

    private String extractTableAlias(Expression expr) {
        if (expr instanceof ExpressionColumn) {
            return ((ExpressionColumn) expr).getTableAlias();
        }
        return null;
    }

    private boolean hasJoinWithAny(TableFilter candidate, List<TableFilter> placed, Set<String> joinPairs) {
        String candAlias = candidate.getTableAlias();
        for (TableFilter other : placed) {
            String otherAlias = other.getTableAlias();
            if (joinPairs.contains(makeKey(candAlias, otherAlias))) {
                return true;
            }
        }
        return false;
    }

    private String makeKey(String a, String b) {
        return (a.compareTo(b) < 0) ? a + "-" + b : b + "-" + a;
    }

    private TableFilter findSmallest(List<TableFilter> list) {
        return list.stream()
                .min(Comparator.comparingLong(f -> f.getTable().getRowCountApproximation(session)))
                .orElseThrow();
    }
}