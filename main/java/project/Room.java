package project;

public class Room {
	
	private String roomID;
    private int price;
    private String amenity;
    private int capacity;
    private String roomView;
    private boolean extraBed;
    private String damage;
    private String hotelID;

    public Room(String roomID, int price, String amenity, int capacity, String roomView, boolean extraBed, String damage, String hotelID) {
        this.roomID = roomID;
        this.price = price;
        this.amenity = amenity;
        this.capacity = capacity;
        this.roomView = roomView;
        this.extraBed = extraBed;
        this.damage = damage;
        this.hotelID = hotelID;
    }

    public String getRoomID() {
        return roomID;
    }

    public void setRoomID(String roomID) {
        this.roomID = roomID;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getAmenity() {
        return amenity;
    }

    public void setAmenity(String amenity) {
        this.amenity = amenity;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getRoomView() {
        return roomView;
    }

    public void setRoomView(String roomView) {
        this.roomView = roomView;
    }

    public boolean isExtraBed() {
        return extraBed;
    }

    public void setExtraBed(boolean extraBed) {
        this.extraBed = extraBed;
    }

    public String getDamage() {
        return damage;
    }

    public void setDamage(String damage) {
        this.damage = damage;
    }

    public String getHotelID() {
        return hotelID;
    }

    public void setHotelID(String hotelID) {
        this.hotelID = hotelID;
    }

}
