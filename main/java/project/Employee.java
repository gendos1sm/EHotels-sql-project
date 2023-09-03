package project;

public class Employee {
    private String employeeId;
    private long SIN;
    private String name;
    private String address;
    private String position;
    private boolean managesHotel;
    private String hotelId;

    public Employee(String employeeId, long SIN, String name, String address, String position, boolean managesHotel, String hotelId) {
        this.employeeId = employeeId;
        this.SIN = SIN;
        this.name = name;
        this.address = address;
        this.position = position;
        this.managesHotel = managesHotel;
        this.hotelId = hotelId;
    }

    public String getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }

    public long getSIN() {
        return SIN;
    }

    public void setSIN(long SIN) {
        this.SIN = SIN;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public boolean isManagesHotel() {
        return managesHotel;
    }

    public void setManagesHotel(boolean managesHotel) {
        this.managesHotel = managesHotel;
    }

    public String getHotelId() {
        return hotelId;
    }

    public void setHotelId(String hotelId) {
        this.hotelId = hotelId;
    }
}