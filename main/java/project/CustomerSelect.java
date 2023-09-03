package project;

import java.sql.*;

public class CustomerSelect {
	
	public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/hotels";
        String username = "root";
        String password = "qwerty12345";

        try{
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            Statement statement = connection.createStatement();
            
            // Reading values from Table
            String query = "SELECT * FROM customer";
            SelectFromCustomer(statement, query);
   
            statement.close();
            connection.close();
        }catch (SQLException e){
            System.out.println("Error in connecting to MySQL server");
            e.printStackTrace();
        }
    }
    
    
    private static void SelectFromCustomer(Statement statement, String query) throws SQLException {
        ResultSet rs = statement.executeQuery(query);

        while (rs.next())
        {
            System.out.println(rs.getInt("Customer_ID"));
            System.out.println(rs.getString("Full_Name"));
            System.out.println(rs.getString("Address"));
            System.out.println(rs.getLong("SIN"));
        }

        // TO get the number of columns returned by the Query
        ResultSetMetaData rsMetaData = rs.getMetaData();
        int numberOfColumns = rsMetaData.getColumnCount();
        System.out.println("Number of Columns:"+numberOfColumns);
        rs.close();
    }

}
