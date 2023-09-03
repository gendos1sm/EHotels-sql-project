package project;


public class Booking {
    private String bookingID;
    private String checkIn;
    private String checkOut;
    private int amount;

    public Booking(String bookingID, String checkIn, String checkOut, int amount) {
        this.bookingID = bookingID;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.amount = amount;
    }

    public String getBookingID() {
        return bookingID;
    }

    public void setBookingID(String bookingID) {
        this.bookingID = bookingID;
    }

    public String getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(String checkIn) {
        this.checkIn = checkIn;
    }

    public String getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(String checkOut) {
        this.checkOut = checkOut;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }
}