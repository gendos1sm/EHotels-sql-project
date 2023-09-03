package project;

import java.sql.*;

public class EmployeeDatabase {

    public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/hotels";
        String username = "root";
        String password = "qwerty12345";
        try{
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            //Employee employee1 = new Employee("E0002", 123456789, "John Smith", "Ottawa, ON", "Manager", true, "M0003");
            
            //updateEmployee(connection, employee1);
            //insertEmployee(connection, employee1);
            
            String employeeID = "E0002";
            deleteEmployee(connection, employeeID);
            //System.out.println("Connected to MySQL server");
            connection.close();
        }catch (SQLException e){
            System.out.println("Error in connecting to MySQL server");
            e.printStackTrace();
        }
    }

    public static void insertEmployee(Connection connection, Employee employee) throws SQLException {
    	
    	PreparedStatement statement = connection.prepareStatement("INSERT INTO employee(Employee_ID, SIN, Employee_Name, Address, Position, Manages_Hotel, Hotel_ID) VALUES (?, ?, ?, ?, ?, ?, ?)");
        statement.setString(1, employee.getEmployeeId());
        statement.setLong(2, employee.getSIN());
        statement.setString(3, employee.getName());
        statement.setString(4, employee.getAddress());
        statement.setString(5, employee.getPosition());
        statement.setBoolean(6, employee.isManagesHotel());
        statement.setString(7, employee.getHotelId());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("New row inserted into database");
        }else{
            System.out.println("Insert Failed");
        }
    }

    public static void updateEmployee(Connection connection, Employee employee) throws SQLException {

    	PreparedStatement statement = connection.prepareStatement("UPDATE employee SET SIN = ?, Employee_Name = ?, Address = ?, Position = ?, Manages_Hotel = ?, Hotel_ID = ? WHERE Employee_ID = ?");
        statement.setLong(1, employee.getSIN());
        statement.setString(2, employee.getName());
        statement.setString(3, employee.getAddress());
        statement.setString(4, employee.getPosition());
        statement.setBoolean(5, employee.isManagesHotel());
        statement.setString(6, employee.getHotelId());
        statement.setString(7, employee.getEmployeeId());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Updated");
        }else{
            System.out.println("Update Failed");
        }

    }

    public static void deleteEmployee(Connection connection, String employeeId) throws SQLException {
            
    	PreparedStatement statement = connection.prepareStatement("DELETE FROM employee WHERE Employee_ID = ?");
        statement.setString(1, employeeId);
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Deleted");
        }else{
            System.out.println("Delete Failed");
        }
    }
}
