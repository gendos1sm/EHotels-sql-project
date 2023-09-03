package project;

public class Customer {
    private int id;
    private String fullName;
    private String address;
    private long sin;

    public Customer(int id, String fullName, String address, long sin) {
        this.id = id;
        this.fullName = fullName;
        this.address = address;
        this.sin = sin;
    }

    public int getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public long getSin() {
        return sin;
    }

    public void setSin(long sin) {
        this.sin = sin;
    }
}
