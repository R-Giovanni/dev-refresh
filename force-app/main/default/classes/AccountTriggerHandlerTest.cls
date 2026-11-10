@IsTest
private class AccountTriggerHandlerTest {

    private static final Integer BULK_SIZE = 251;
    private static final String CUSTOM_DESCRIPTION = 'Custom description';

    @IsTest
    static void shouldSetDefaultDescription_WhenInsertedWithoutDescription() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(1, null, false);

        // When
        Test.startTest();
        insert accounts;
        Test.stopTest();

        // Then
        Account inserted = [SELECT Description FROM Account WHERE Id = :accounts[0].Id];
        Assert.areEqual(AccountDomain.DEFAULT_ACC_DESCRIPTION, inserted.Description, 'Default description should be set on insert');
    }

    @IsTest
    static void shouldKeepDescription_WhenInsertedWithDescription() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(1, CUSTOM_DESCRIPTION, false);

        // When
        Test.startTest();
        insert accounts;
        Test.stopTest();

        // Then
        Account inserted = [SELECT Description FROM Account WHERE Id = :accounts[0].Id];
        Assert.areEqual(CUSTOM_DESCRIPTION, inserted.Description, 'Existing description should not be overwritten');
    }

    @IsTest
    static void shouldSetDefaultOnlyOnBlankOnes_WhenMixedBatch() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(2, null, false);
        accounts.addAll(TestDataFactory.createAccounts(3, CUSTOM_DESCRIPTION, false));

        // When
        Test.startTest();
        insert accounts;
        Test.stopTest();

        // Then
        Assert.areEqual(2, countWithDescription(accounts, AccountDomain.DEFAULT_ACC_DESCRIPTION), 'Only blank accounts should get the default');
        Assert.areEqual(3, countWithDescription(accounts, CUSTOM_DESCRIPTION), 'Accounts with a description should be untouched');
    }

    @IsTest
    static void shouldSetDefaultDescription_WhenBulkInsert() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(BULK_SIZE, null, false);

        // When
        Test.startTest();
        insert accounts;
        Test.stopTest();

        // Then
        Assert.areEqual(BULK_SIZE, countWithDescription(accounts, AccountDomain.DEFAULT_ACC_DESCRIPTION), 'All accounts across trigger batches should get the default');
    }

    @IsTest
    static void shouldNotSetDescription_WhenHandlerBypassed() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(1, null, false);
        TriggerHandler.bypass('AccountTriggerHandler');

        // When
        Test.startTest();
        insert accounts;
        Test.stopTest();
        TriggerHandler.clearBypass('AccountTriggerHandler');

        // Then
        Account inserted = [SELECT Description FROM Account WHERE Id = :accounts[0].Id];
        Assert.isNull(inserted.Description, 'Description should stay empty when the handler is bypassed');
    }

    @IsTest
    static void shouldNotChangeDescription_WhenUpdated() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(1, CUSTOM_DESCRIPTION, true);
        accounts[0].Description = null;

        // When
        Test.startTest();
        update accounts;
        Test.stopTest();

        // Then
        Account updated = [SELECT Description FROM Account WHERE Id = :accounts[0].Id];
        Assert.isNull(updated.Description, 'The trigger only runs before insert, so updates should not set the default');
    }

    // Description is a long text area and can not be filtered in SOQL, so count in Apex
    private static Integer countWithDescription(List<Account> accounts, String expectedDescription) {
        Integer matches = 0;
        for (Account acc : [SELECT Description FROM Account WHERE Id IN :accounts]) {
            if (acc.Description == expectedDescription) {
                matches++;
            }
        }
        return matches;
    }
}
