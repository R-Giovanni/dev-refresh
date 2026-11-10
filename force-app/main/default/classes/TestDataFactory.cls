/**
 * Builds test data for Apex tests.
 */
@IsTest
public class TestDataFactory {

    /**
     * Builds accounts named "Test Account N" with the given description.
     * @param count Number of accounts to build
     * @param description Description to set on every account, may be null
     * @param doInsert Whether to insert the accounts before returning them
     * @return The built accounts
     * @example
     * List<Account> accounts = TestDataFactory.createAccounts(251, null, true);
     */
    public static List<Account> createAccounts(Integer count, String description, Boolean doInsert) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i, Description = description));
        }
        if (doInsert) {
            insert accounts;
        }
        return accounts;
    }
}
