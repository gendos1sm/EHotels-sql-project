package project;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class RoomSelection {
	public static List<Room> roomList() throws ClassNotFoundException {
        String jdbcURL = "jdbc:mysql://localhost:3306/hotels";
        String username = "root";
        String password = "qwerty12345";
        List<Room> availRoom = new ArrayList<>();

        try{
        	Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            Statement statement = connection.createStatement();
            
            // Reading values from Table
            String query = "SELECT * FROM room";
            ResultSet rs = statement.executeQuery(query);

            while (rs.next())
            {
                String id = rs.getString("Room_ID");
                int price = rs.getInt("Price");
                String amenity= rs.getString("Amenity");
                int cap = rs.getInt("Capacity");
                String view = rs.getString("Room_View");
                
                Boolean bed = rs.getBoolean("Extra_Bed");
                String damage = rs.getString("Damage");
                String hotelID = rs.getString("Hotel_ID"); 
                
                Room temp = new Room(id,price,amenity,cap,view, bed, damage, hotelID);
                availRoom.add(temp);
            }
            
        }catch (SQLException e){
            System.out.println("Error in connecting to MySQL server");
            e.printStackTrace();
        }
        return availRoom;
    }
    
    
}
