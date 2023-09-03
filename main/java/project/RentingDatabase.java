package project;

import java.sql.*;

public class RentingDatabase {
	public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/hotels";
        String username = "root";
        String password = "qwerty12345";
        try{
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            //Renting renting1 = new Renting("B0001", "2023-10-21", "2023-10-30", 250);
            
            //updateRenting(connection, renting1);
            //insertRenting(connection, renting1);
            
            String rentingID = "B0001";
            deleteRenting(connection, rentingID);
            //System.out.println("Connected to MySQL server");
            connection.close();
        }catch (SQLException e){
            System.out.println("Error in connecting to MySQL server");
            e.printStackTrace();
        }
    }

    public static void insertRenting(Connection connection, Renting renting) throws SQLException {
    	
    	PreparedStatement statement = connection.prepareStatement("INSERT INTO renting(Renting_ID, Check_In, Check_Out, Amount) VALUES (?, ?, ?, ?)");
        statement.setString(1, renting.getRentingID());
        statement.setString(2, renting.getCheckIn());
        statement.setString(3, renting.getCheckOut());
        statement.setInt(4, renting.getAmount());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("New row inserted into database");
        }else{
            System.out.println("Insert Failed");
        }
    }

    public static void updateRenting(Connection connection, Renting renting) throws SQLException {

    	PreparedStatement statement = connection.prepareStatement("UPDATE renting SET Amount = ?, Check_In = ?, Check_Out = ? WHERE Renting_ID = ?");
    	statement.setInt(1, renting.getAmount());
    	statement.setString(2, renting.getCheckIn());
    	statement.setString(3, renting.getCheckOut());
        statement.setString(4, renting.getRentingID());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Updated");
        }else{
            System.out.println("Update Failed");
        }

    }

    public static void deleteRenting(Connection connection, String rentingId) throws SQLException {
            
    	PreparedStatement statement = connection.prepareStatement("DELETE FROM renting WHERE Renting_ID = ?");
        statement.setString(1, rentingId);
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Deleted");
        }else{
            System.out.println("Delete Failed");
        }
    }


}
