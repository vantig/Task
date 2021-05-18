/**
 * Created by igordeychik on 5/17/2021.
 */

public with sharing class AccountHelper {
    private List<Account>accounts=new List<Account>();
    private List<String>names=new List<String>();
    private List<Account>accountsToInsert=new List<Account>();
    public AccountHelper(List<String>names){
        this.names=names;
        accounts = [SELECT  Name FROM Account WHERE Name IN :names];
        System.debug([SELECT  Name FROM Account]);
    }
    public void reQueryByNames(){
        Boolean isNameExist;
        for (String name:names){
            isNameExist=false;
            for (Account acc : accounts) {
                if (name == acc.Name) {
                    isNameExist=true;
                }
            }
            if (!isNameExist) {
                accountsToInsert.add(new Account(Name=name));
            }
        }
        insert accountsToInsert;

        accounts = [SELECT  Name FROM Account WHERE Name IN :names];
    }
    public  Account getAccount(String accName) {//return ex acc or null
        for (Account acc : accounts) {
            if (acc.Name == accName) {
                return acc;
            }
        }
        return null;
    }

}