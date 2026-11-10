/**
 * Domain rules for Account records. Operates on in-memory lists only (no SOQL or DML).
 */
public with sharing class AccountDomain {

    @TestVisible
    private static final String DEFAULT_ACC_DESCRIPTION = 'This is a default account description';

    private AccountDomain() { // NOPMD
        // Made private so this domain class can not be instantiated
    }

    /**
     * Sets the default description on every account that has no description.
     * Accounts that already have a description are left untouched.
     * @param accounts Accounts to update in memory
     * @return The same list that was passed in, or an empty list when the input is null
     * @example
     * AccountDomain.setDefaultDescription(Trigger.new);
     */
    public static List<Account> setDefaultDescription(List<Account> accounts) {
        List<Account> accsToProcess = AccountFilter.filterWithNoDescription(accounts);
        if (accsToProcess.isEmpty()) {
            return accsToProcess;
        }
        for (Account currentAcc : accsToProcess) {
            currentAcc.Description = DEFAULT_ACC_DESCRIPTION;
        }
        return accounts;
    }
}
