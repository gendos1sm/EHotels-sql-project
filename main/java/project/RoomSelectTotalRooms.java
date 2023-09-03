package project;

import java.sql.*;

public class RoomSelectTotalRooms {
	
	public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/hotels";
        String username = "root";
        String password = "qwerty12345";

        try{
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            Statement statement = connection.createStatement();
            
            // Reading values from Table
            String query = "SELECT * FROM hotel WHERE Num_Rooms >= ?";
            // Select rooms by total number of rooms
            
            SelectByTotalRooms(statement, query);
   
            statement.close();
            connection.close();
        }catch (SQLException e){
            System.out.println("Error in connecting to MySQL server");
            e.printStackTrace();
        }
    }
    
    
    private static void SelectByTotalRooms(Statement statement, String query) throws SQLException {
        ResultSet rs = statement.executeQuery(query);

        while (rs.next())
        {
            System.out.println(rs.getString("Room_ID"));
            System.out.println(rs.getInt("Price"));
            System.out.println(rs.getString("Amenity"));
            System.out.println(rs.getInt("Capacity"));
            System.out.println(rs.getString("Room_View"));
            System.out.println(rs.getBoolean("Extra_Bed"));
            System.out.println(rs.getString("Damage"));
            System.out.println(rs.getString("Hotel_ID"));
            
        }

        // TO get the number of columns returned by the Query
        ResultSetMetaData rsMetaData = rs.getMetaData();
        int numberOfColumns = rsMetaData.getColumnCount();
        System.out.println("Number of Columns:"+numberOfColumns);
        rs.close();
    }

}
