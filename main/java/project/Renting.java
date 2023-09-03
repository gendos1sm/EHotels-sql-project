package project;

public class Renting {
	private String rentingID;
    private String checkIn;
    private String checkOut;
    private int amount;

    public Renting(String rentingID, String checkIn, String checkOut, int amount) {
        this.rentingID = rentingID;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.amount = amount;
    }

    public String getRentingID() {
        return rentingID;
    }

    public void setRentingID(String rentingID) {
        this.rentingID = rentingID;
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
