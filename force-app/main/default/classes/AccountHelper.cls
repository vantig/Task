/**
 * Created by igordeychik on 5/17/2021.
 */

public with sharing class AccountHelper {
    private List<Account>accounts=new List<Account>();
    public AccountHelper(List<String>names){
        accounts = [SELECT  Name FROM Account WHERE Name IN :names];
    }

    public  Account getAccount(String accName) {//return ex acc or create new
        for (Account acc : accounts) {
            if (acc.Name == accName) return acc;
        }
        Account newAccount = new Account(Name = accName);
        return newAccount;
    }

}