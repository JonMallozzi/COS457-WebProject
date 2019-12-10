/*

test strings for acceptability to java.sql.Date's valueOf
method

What my testing appears to show about valueOf is

1. there must be 4 decimal digits for the year; 0000 is
   accepted and converted to 0001
2. the separator character must be '-'
3. there can be 1 or 2 decimal digits for the month or day,
   and a leading 0 is acceptable for values from 1 to 9,
   but numbers out of the range 1 to 12 for months and 1 to 31
   for days will be rejected
4. as long as the month and day are in those ranges, invalid
   date values will not throw an exception but will be advanced
   to the next month enough days to correct the invalidity,
   e.g., 2000-6-31 becomes 2000-07-01.

*/

import java.util.Scanner;
import java.sql.Date;

public class testSQLDate{

   private static Scanner stdIn = new Scanner(System.in);

   public static void main(String[] a){


      String s  = null;

      System.out.println("Enter strings to pass on to java.sql.Date.valueOf, or ^Z to quit.");

      java.sql.Date dt;
      
      while (stdIn.hasNext()){
         s = stdIn.next();

         dt = null;

         try{
            dt = java.sql.Date.valueOf(s);

            System.out.println("conversion was successful; date is " + dt.toString());
         }
         catch(IllegalArgumentException e){
            System.out.println("conversion failed. IllegalArgumentException was thrown."
            + " message is " + e.getMessage());
            e.printStackTrace();
         }
         catch (Exception e){
            System.out.println("conversion was unsuccessful. message is " + e.getMessage());
            e.printStackTrace();
         }
      }
      // try values for  months from 00 to 13
      char[]
      year = { '0','0','0','0', '-'},
      mnth = { '0', '0', '-'},
      dy = { '0', '1'};
      StringBuilder bld = new StringBuilder();
      // test for month range
      for (int i = 0; i < 14; i++){
         bld.append(year);
         bld.append(mnth);
         bld.append(dy);
         
         try{
            s = bld.toString();
            System.out.println("Attempting to convert \'" + s + "\'");
            dt = java.sql.Date.valueOf(s);

            System.out.println("conversion was successful; date is " + dt.toString());
         }
         catch(IllegalArgumentException e){
            System.out.println("conversion failed. IllegalArgumentException was thrown."
            + " message is " + e.getMessage());
            e.printStackTrace();
         }
         catch (Exception e){
            System.out.println("conversion was unsuccessful. message is " + e.getMessage());
            e.printStackTrace();
         }
         bld.delete(0,bld.length());
         mnth[1]++;
         if (mnth[1] == ':'){
            mnth[0] = '1';
            mnth[1] = '0';
         }
      }
            
      mnth[0] = '0';
      mnth[1] = '1';
      dy[0] = dy[1] = '0';
      // test for day range; use January for the month
      for (int i = 0; i < 33; i++){
         bld.append(year);
         bld.append(mnth);
         bld.append(dy);
         
         try{
            s = bld.toString();
            System.out.println("Attempting to convert \'" + s + "\'");
            dt = java.sql.Date.valueOf(s);

            System.out.println("conversion was successful; date is " + dt.toString());
         }
         catch(IllegalArgumentException e){
            System.out.println("conversion failed. IllegalArgumentException was thrown."
            + " message is " + e.getMessage());
            e.printStackTrace();
         }
         catch (Exception e){
            System.out.println("conversion was unsuccessful. message is " + e.getMessage());
            e.printStackTrace();
         }
         bld.delete(0,bld.length());
         dy[1]++;
         if (dy[1] == ':'){
            dy[0]++;
            dy[1] = '0';
         }
      }
      
      // test days out of range for non-February months
      String[] shortMonths = { "4", "6", "9", "11" };
      dy[0] = '3';
      dy[1] = '1';
      year[0] = year[1] = year[2] = year[3] = '9';
      for (int i = 0; i < shortMonths.length; i++){
         bld.append(year);
         bld.append(shortMonths[i]);
         bld.append('-');
         bld.append(dy);
         
         try{
            s = bld.toString();
            System.out.println("Attempting to convert \'" + s + "\'");
            dt = java.sql.Date.valueOf(s);

            System.out.println("conversion was successful; date is " + dt.toString());
         }
         catch(IllegalArgumentException e){
            System.out.println("conversion failed. IllegalArgumentException was thrown."
            + " message is " + e.getMessage());
            e.printStackTrace();
         }
         catch (Exception e){
            System.out.println("conversion was unsuccessful. message is " + e.getMessage());
            e.printStackTrace();
         }
         bld.delete(0,bld.length());
      }
         
          // test days out of range for February
      String[] febYears = { "1963-", "1964-", "2100-", "2000-" };
      dy[0] = '2';
      dy[1] = '9';
      for (int i = 0; i < febYears.length; i++){
         bld.append(febYears[i]);
         bld.append("2-");
         bld.append(dy);
         
         try{
            s = bld.toString();
            System.out.println("Attempting to convert \'" + s + "\'");
            dt = java.sql.Date.valueOf(s);

            System.out.println("conversion was successful; date is " + dt.toString());
         }
         catch(IllegalArgumentException e){
            System.out.println("conversion failed. IllegalArgumentException was thrown."
            + " message is " + e.getMessage());
            e.printStackTrace();
         }
         catch (Exception e){
            System.out.println("conversion was unsuccessful. message is " + e.getMessage());
            e.printStackTrace();
         }
         bld.delete(7,bld.length());
         bld.append("30"); 
         try{
            s = bld.toString();
            System.out.println("Attempting to convert \'" + s + "\'");
            dt = java.sql.Date.valueOf(s);

            System.out.println("conversion was successful; date is " + dt.toString());
         }
         catch(IllegalArgumentException e){
            System.out.println("conversion failed. IllegalArgumentException was thrown."
            + " message is " + e.getMessage());
            e.printStackTrace();
         }
         catch (Exception e){
            System.out.println("conversion was unsuccessful. message is " + e.getMessage());
            e.printStackTrace();
         }
         
         
         bld.delete(0,bld.length());
      }
      
      // check all month day combinations
      int exceptionCount = 0;
      
      for (int month = 1; month <= 12; month++)
         for (int day = 1; day <= 31; day++){
            try{
               s = "1963-" + month + "-" + day;
               System.out.println("Trying " + s);
               dt = java.sql.Date.valueOf(s);
            }
            catch(IllegalArgumentException e){
               exceptionCount++;
            }
         }
         
      System.out.println("Exceptions thrown = " + exceptionCount);
               
   }
   
}

 