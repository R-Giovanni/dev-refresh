@IsTest
private class AccountDomainTest {

    private static final Integer BULK_SIZE = 251;

    @IsTest
    static void shouldSetDefaultDescription_WhenDescriptionIsBlank() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(1, null, false);

        // When
        Test.startTest();
        AccountDomain.setDefaultDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual(AccountDomain.DEFAULT_ACC_DESCRIPTION, accounts[0].Description, 'Description should be set to the default');
    }

    @IsTest
    static void shouldKeepDescription_WhenDescriptionAlreadySet() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(1, 'Existing description', false);

        // When
        Test.startTest();
        AccountDomain.setDefaultDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual('Existing description', accounts[0].Description, 'An existing description should not be replaced');
    }

    @IsTest
    static void shouldReturnEmptyList_WhenListIsNull() {
        // When
        Test.startTest();
        List<Account> result = AccountDomain.setDefaultDescription(null);
        Test.stopTest();

        // Then
        Assert.isNotNull(result, 'Result should never be null');
        Assert.areEqual(0, result.size(), 'Null input should return an empty list');
    }

    @IsTest
    static void shouldOnlyFillBlankOnes_WhenMixed() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(2, null, false);
        accounts.addAll(TestDataFactory.createAccounts(3, 'Existing description', false));

        // When
        Test.startTest();
        AccountDomain.setDefaultDescription(accounts);
        Test.stopTest();

        // Then
        Integer defaults = 0;
        Integer kept = 0;
        for (Account acc : accounts) {
            if (acc.Description == AccountDomain.DEFAULT_ACC_DESCRIPTION) {
                defaults++;
            } else if (acc.Description == 'Existing description') {
                kept++;
            }
        }
        Assert.areEqual(2, defaults, 'Only the blank accounts should get the default');
        Assert.areEqual(3, kept, 'Accounts with a description should be untouched');
    }

    @IsTest
    static void shouldReturnSameList_WhenCalled() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(2, null, false);

        // When
        Test.startTest();
        List<Account> result = AccountDomain.setDefaultDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual(2, result.size(), 'All accounts should be returned');
        Assert.areEqual(accounts, result, 'The input list should be returned');
    }

    @IsTest
    static void shouldReturnEmptyList_WhenListIsEmpty() {
        // Given
        List<Account> accounts = new List<Account>();

        // When
        Test.startTest();
        List<Account> result = AccountDomain.setDefaultDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual(0, result.size(), 'An empty list should stay empty');
    }

    @IsTest
    static void shouldSetDefaultDescription_WhenBulk() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(BULK_SIZE, null, false);

        // When
        Test.startTest();
        AccountDomain.setDefaultDescription(accounts);
        Test.stopTest();

        // Then
        for (Account acc : accounts) {
            Assert.areEqual(AccountDomain.DEFAULT_ACC_DESCRIPTION, acc.Description, 'Every account should get the default description');
        }
    }
}
