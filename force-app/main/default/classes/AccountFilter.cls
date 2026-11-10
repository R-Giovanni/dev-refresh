/**
 * Pure in-memory filters over Account lists. Works on any source: Trigger.new, SOQL results or test data.
 */
public with sharing class AccountFilter {

    private AccountFilter() { // NOPMD
        // Made private so this utility class can not be instantiated
    }

    /**
     * Returns the accounts whose description is null, empty or whitespace only.
     * @param accs Accounts to filter
     * @return Accounts with no description, or an empty list when the input is null or empty
     * @example
     * List<Account> blankOnes = AccountFilter.filterWithNoDescription(Trigger.new);
     */
    public static List<Account> filterWithNoDescription(List<Account> accs) {
        List<Account> accsToReturn = new List<Account>();
        if (accs == null || accs.isEmpty()) {
            return accsToReturn;
        }
        for (Account currentAcc : accs) {
            if (String.isBlank(currentAcc.Description)) {
                accsToReturn.add(currentAcc);
            }
        }
        return accsToReturn;
    }
}
