@IsTest
private class AccountFilterTest {

    private static final Integer BULK_SIZE = 251;

    @IsTest
    static void shouldReturnAccounts_WhenDescriptionIsNull() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(2, null, false);

        // When
        Test.startTest();
        List<Account> result = AccountFilter.filterWithNoDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual(2, result.size(), 'Accounts with null description should be returned');
    }

    @IsTest
    static void shouldReturnAccounts_WhenDescriptionIsEmptyString() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(2, '', false);

        // When
        Test.startTest();
        List<Account> result = AccountFilter.filterWithNoDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual(2, result.size(), 'Accounts with empty description should be returned');
    }

    @IsTest
    static void shouldReturnAccounts_WhenDescriptionIsWhitespace() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(2, '   ', false);

        // When
        Test.startTest();
        List<Account> result = AccountFilter.filterWithNoDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual(2, result.size(), 'Accounts with whitespace description should be returned');
    }

    @IsTest
    static void shouldExcludeAccounts_WhenDescriptionHasValue() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(2, 'Has a description', false);

        // When
        Test.startTest();
        List<Account> result = AccountFilter.filterWithNoDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual(0, result.size(), 'Accounts with a description should be excluded');
    }

    @IsTest
    static void shouldReturnOnlyBlankOnes_WhenMixed() {
        // Given
        List<Account> withDescription = TestDataFactory.createAccounts(3, 'Has a description', false);
        List<Account> withoutDescription = TestDataFactory.createAccounts(2, null, false);
        List<Account> accounts = new List<Account>();
        accounts.addAll(withDescription);
        accounts.addAll(withoutDescription);

        // When
        Test.startTest();
        List<Account> result = AccountFilter.filterWithNoDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual(withoutDescription.size(), result.size(), 'Only accounts without description should be returned');
        for (Account acc : result) {
            Assert.isTrue(String.isBlank(acc.Description), 'Returned accounts should have a blank description');
        }
    }

    @IsTest
    static void shouldReturnEmptyList_WhenInputIsNull() {
        // When
        Test.startTest();
        List<Account> result = AccountFilter.filterWithNoDescription(null);
        Test.stopTest();

        // Then
        Assert.isNotNull(result, 'Result should never be null');
        Assert.areEqual(0, result.size(), 'Null input should return an empty list');
    }

    @IsTest
    static void shouldReturnEmptyList_WhenInputIsEmpty() {
        // When
        Test.startTest();
        List<Account> result = AccountFilter.filterWithNoDescription(new List<Account>());
        Test.stopTest();

        // Then
        Assert.isNotNull(result, 'Result should never be null');
        Assert.areEqual(0, result.size(), 'Empty input should return an empty list');
    }

    @IsTest
    static void shouldFilterCorrectly_WhenBulk() {
        // Given
        List<Account> accounts = TestDataFactory.createAccounts(BULK_SIZE, null, false);
        accounts.addAll(TestDataFactory.createAccounts(BULK_SIZE, 'Has a description', false));

        // When
        Test.startTest();
        List<Account> result = AccountFilter.filterWithNoDescription(accounts);
        Test.stopTest();

        // Then
        Assert.areEqual(BULK_SIZE, result.size(), 'Only the accounts without description should be returned');
    }
}
