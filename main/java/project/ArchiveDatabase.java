package project;

import java.sql.*;

public class ArchiveDatabase {
	public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/hotels";
        String username = "root";
        String password = "qwerty12345";

        try{
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            //Archive record1 = new Archive("B0001", "2023-10-21", "2023-10-30", 250);
            
            //updateArchive(connection, record1);
            //insertArchive(connection, record1);
            
            String recordID = "B0001";
            deleteArchive(connection, recordID);
            //System.out.println("Connected to MySQL server");
            connection.close();
        }catch (SQLException e){
            System.out.println("Error in connecting to MySQL server");
            e.printStackTrace();
        }
    }

    public static void insertArchive(Connection connection, Archive record) throws SQLException {
    	
    	PreparedStatement statement = connection.prepareStatement("INSERT INTO archive(Record_ID, Check_In, Check_Out, Amount) VALUES (?, ?, ?, ?)");
        statement.setString(1, record.getRecordID());
        statement.setString(2, record.getCheckIn());
        statement.setString(3, record.getCheckOut());
        statement.setInt(4, record.getAmount());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("New row inserted into database");
        }else{
            System.out.println("Insert Failed");
        }
    }

    public static void updateArchive(Connection connection, Archive record) throws SQLException {

    	PreparedStatement statement = connection.prepareStatement("UPDATE archive SET Amount = ?, Check_In = ?, Check_Out = ? WHERE Record_ID = ?");
    	statement.setInt(1, record.getAmount());
    	statement.setString(2, record.getCheckIn());
    	statement.setString(3, record.getCheckOut());
        statement.setString(4, record.getRecordID());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Updated");
        }else{
            System.out.println("Update Failed");
        }

    }

    public static void deleteArchive(Connection connection, String recordId) throws SQLException {
            
    	PreparedStatement statement = connection.prepareStatement("DELETE FROM archive WHERE Record_ID = ?");
        statement.setString(1, recordId);
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Deleted");
        }else{
            System.out.println("Delete Failed");
        }
    }


}
