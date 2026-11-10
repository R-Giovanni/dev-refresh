/**
 * Routes Account trigger events to the domain rules. Currently handles before insert only.
 */
public with sharing class AccountTriggerHandler extends TriggerHandler {
    private List<Account> newAccs;

    /**
     * Captures the records being processed by the current trigger.
     */
    public AccountTriggerHandler() {
        this.newAccs = Trigger.new;
    }

    /**
     * Sets the default description on new accounts that have none.
     */
    protected override void beforeInsert() {
        AccountDomain.setDefaultDescription(newAccs);
    }
}
