package project;

import java.sql.*;

public class RoomDatabase {
	public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/hotels";
        String username = "root";
        String password = "qwerty12345";

        try{
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            //Room room1 = new Room(?, ?, ?, ?, ?, ?, ?, ?);
            
            //updateRoom(connection, room1);
            //insertRoom(connection, room1);
            
            String roomID = "?????";
            deleteRoom(connection, roomID);
            //System.out.println("Connected to MySQL server");
            connection.close();
        }catch (SQLException e){
            System.out.println("Error in connecting to MySQL server");
            e.printStackTrace();
        }
    }

    public static void insertRoom(Connection connection, Room room) throws SQLException {
    	
    	PreparedStatement statement = connection.prepareStatement("INSERT INTO room(Room_ID, Price, Amenity, Capacity, Room_View, Extra_Bed, Damage, Hotel_ID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        statement.setString(1, room.getRoomID());
        statement.setInt(2, room.getPrice());
        statement.setString(3, room.getAmenity());
        statement.setInt(4, room.getCapacity());
        statement.setString(5, room.getRoomView());
        statement.setBoolean(6, room.isExtraBed());
        statement.setString(7, room.getDamage());
        statement.setString(8, room.getHotelID());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("New row inserted into database");
        }else{
            System.out.println("Insert Failed");
        }
    }

    public static void updateRoom(Connection connection, Room room) throws SQLException {

    	PreparedStatement statement = connection.prepareStatement("UPDATE room SET Price = ?, Amenity = ?, Capacity = ?, Room_View = ?, Extra_Bed = ?, Damage = ?, Hotel_ID = ? WHERE Room_ID = ?");
    	statement.setInt(1, room.getPrice());
        statement.setString(2, room.getAmenity());
        statement.setInt(3, room.getCapacity());
        statement.setString(4, room.getRoomView());
        statement.setBoolean(5, room.isExtraBed());
        statement.setString(6, room.getDamage());
        statement.setString(7, room.getHotelID());
        statement.setString(8, room.getRoomID());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Updated");
        }else{
            System.out.println("Update Failed");
        }

    }

    public static void deleteRoom(Connection connection, String roomId) throws SQLException {
            
    	PreparedStatement statement = connection.prepareStatement("DELETE FROM room WHERE Room_ID = ?");
        statement.setString(1, roomId);
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Deleted");
        }else{
            System.out.println("Delete Failed");
        }
    }

}
