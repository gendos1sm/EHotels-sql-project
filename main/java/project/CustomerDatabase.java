package project;

import java.sql.*;

public class CustomerDatabase {
	
	public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/hotels";
        String username = "root";
        String password = "qwerty12345";

        try{
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            //Customer customer1 = new Customer(3, "John Geek", "Toronto, ON", 152658021);
            
            //updateCustomer(connection, customer1);
            //insertCustomer(connection, customer1);
            
            int customerID = 2;
            deleteCustomer(connection, customerID);
            //System.out.println("Connected to MySQL server");
            connection.close();
        }catch (SQLException e){
            System.out.println("Error in connecting to MySQL server");
            e.printStackTrace();
        }
    }

    public static void insertCustomer(Connection connection, Customer customer) throws SQLException {
    	
    	PreparedStatement statement = connection.prepareStatement("INSERT INTO customer(Customer_ID, Full_Name, Address, SIN) VALUES (?, ?, ?, ?)");
        statement.setInt(1, customer.getId());
        statement.setString(2, customer.getFullName());
        statement.setString(3, customer.getAddress());
        statement.setLong(4, customer.getSin());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("New row inserted into database");
        }else{
            System.out.println("Insert Failed");
        }
    }

    public static void updateCustomer(Connection connection, Customer customer) throws SQLException {

    	PreparedStatement statement = connection.prepareStatement("UPDATE customer SET SIN = ?, Full_Name = ?, Address = ? WHERE Customer_ID = ?");
        statement.setLong(1, customer.getSin());
        statement.setString(2, customer.getFullName());
        statement.setString(3, customer.getAddress());
        statement.setInt(4, customer.getId());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Updated");
        }else{
            System.out.println("Update Failed");
        }

    }

    public static void deleteCustomer(Connection connection, int customerId) throws SQLException {
            
    	PreparedStatement statement = connection.prepareStatement("DELETE FROM customer WHERE Customer_ID = ?");
        statement.setInt(1, customerId);
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Deleted");
        }else{
            System.out.println("Delete Failed");
        }
    }
}
