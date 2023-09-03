package project;

public class Archive {
	private String recordID;
    private String checkIn;
    private String checkOut;
    private int amount;

    public Archive(String recordID, String checkIn, String checkOut, int amount) {
        this.recordID = recordID;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.amount = amount;
    }

    public String getRecordID() {
        return recordID;
    }

    public void setRecordID(String recordID) {
        this.recordID = recordID;
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
