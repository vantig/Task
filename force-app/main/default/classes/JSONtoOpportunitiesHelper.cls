public with sharing class JSONtoOpportunitiesHelper {
    public static List<Account> newAccounts=new List<Account>();
    public static List<Account> accounts ;
    public static Account getAccount(String accName) {
        for (Account acc : JSONtoOpportunitiesHelper.accounts) {
            if (acc.Name == accName) return acc;
        }
        Account newAccount = new Account(Name = accName);
        newAccounts.add(newAccount);
        return newAccount;
    }

    static {
        accounts = [SELECT Name FROM Account];
    }

}