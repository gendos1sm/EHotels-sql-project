package project;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BookingDatabase {
	
	public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/hotels";
        String username = "root";
        String password = "qwerty12345";

        try{
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            //Booking booking1 = new Booking("B0001", "2023-10-21", "2023-10-30", 250);
            
            //updateBooking(connection, booking1);
            //insertBooking(connection, booking1);
            
            String bookingID = "B0001";
            deleteBooking(connection, bookingID);
            //System.out.println("Connected to MySQL server");
            connection.close();
        }catch (SQLException e){
            System.out.println("Error in connecting to MySQL server");
            e.printStackTrace();
        }
    }

    public static void insertBooking(Connection connection, Booking booking) throws SQLException {
    	
    	PreparedStatement statement = connection.prepareStatement("INSERT INTO booking(Booking_ID, Check_In, Check_Out, Amount) VALUES (?, ?, ?, ?)");
        statement.setString(1, booking.getBookingID());
        statement.setString(2, booking.getCheckIn());
        statement.setString(3, booking.getCheckOut());
        statement.setInt(4, booking.getAmount());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("New row inserted into database");
        }else{
            System.out.println("Insert Failed");
        }
    }

    public static void updateBooking(Connection connection, Booking booking) throws SQLException {

    	PreparedStatement statement = connection.prepareStatement("UPDATE booking SET Amount = ?, Check_In = ?, Check_Out = ? WHERE Booking_ID = ?");
    	statement.setInt(1, booking.getAmount());
    	statement.setString(2, booking.getCheckIn());
    	statement.setString(3, booking.getCheckOut());
        statement.setString(4, booking.getBookingID());
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Updated");
        }else{
            System.out.println("Update Failed");
        }

    }

    public static void deleteBooking(Connection connection, String bookingId) throws SQLException {
            
    	PreparedStatement statement = connection.prepareStatement("DELETE FROM booking WHERE Booking_ID = ?");
        statement.setString(1, bookingId);
        
        int rows = statement.executeUpdate();
        if(rows>0){
            System.out.println("Row Deleted");
        }else{
            System.out.println("Delete Failed");
        }
    }

}
