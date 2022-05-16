//package runner;

import java.sql.CallablesStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatment;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import model.Car;
import model.Owner;

public class OwnerRunner {

	private static final String URL ="jdbc:oracle:thin:@193.6.5.58:1521:XE";
	
	public static void main(String[] args){
	
	try{
		Connection conn = connect("H22_D9WPR7", "D9WPR7;
		
		//createOwnerTable(conn);
		//alterCarTable(conn);
		//addOwner(conn,new Owner(1,"János",new java.sql.Date(new java.util.Date().getTime())));
		//updateOwnerId(conn,1,"Skoda");
		//getAllData(conn);
		//addOwner2(conn,2,"2020-01-01");
		//getCar(conn,"Skoda");
		Scanner sc = new Scanner(System.in);
		System.out.println("Adj meg egy számot");
		callableTest(conn,sc.nextDouble());
		closeDb(conn);
		System.out.println("vége");
	} catch(Exception e){
		e.printStackTrace();
		}
	}
	
	
	public static Connection connect(
			String username, String password)
			throws ClassNotFoundException, SQLException {
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection conn = DriverManager.getConnection(URL, 
				username, password);
		
		return conn;
		
	}
	
	public static void createOwnerTable(Connection conn) throws SQLException {
		PreparedStatement prstmt = conn.prepareStatement(""
				+ "CREATE TABLE owner("
				+ "id int primary key,"
				+ "name varchar2(200),"
				+ "birth date"
				+ ")");
		
		prstmt.executeUpdate();
	}
	
	public static void alterCarTable(Connection conn) throws SQLException {
		Statement stmt = conn.createStatement();
		stmt.executeUpdate(""
				+ "ALTER TABLE car ADD owner_id int "
				+ "CONSTRAINT owner_car REFERENCES owner(id)");
	}
	
		public static void addOwner(Connection conn,Owner owner) throws SQLException {
		PreparedStatement prstmt = conn.prepareStatement(""
				+ "INSERT INTO owner VALUES(?,?,?)");
		prstmt.setInt(1, owner.getId());
		prstmt.setString(2, owner.getName());
		prstmt.setDate(3, owner.getBirth());
		prstmt.executeUpdate();
		prstmt.close();
				
	}
	
	public static void updateOwnerId(Connection conn, int id,
			String manufacturer) throws SQLException {
		PreparedStatement prstmt = conn.prepareStatement(""
				+ "UPDATE car SET owner_id=? where manufacturer=?");
		
		prstmt.setInt(1, id);
		prstmt.setString(2, manufacturer);
		
		System.out.println("updated: "+prstmt.executeUpdate());
		prstmt.close();
	}
	public static void closeDb(Connection conn) throws SQLException {
		conn.close();
	}
	
	public static void getAllData(Connection conn) throws SQLException {
		PreparedStatement prstmt = conn.prepareStatement(""
				+ "SELECT count(*) FROM car c "
				+ "INNER JOIN owner o ON (c.owner_id=o.id)");
		
		ResultSet rs = prstmt.executeQuery();
		while(rs.next()) {
			System.out.println(rs.getString("name")+"\n"+rs.getString("manufacturer"));
		}
		
		//rs.next();
		//System.out.println(rs.getInt(1));
		rs.close();
		prstmt.close();
	}
	public static void addOwner2(Connection conn,int id, String birth) throws SQLException {
		PreparedStatement prstmt = conn.prepareStatement(""
				+ "INSERT INTO owner VALUES(?,?,{d ?})");//"yyyy-mm-dd"
		prstmt.setInt(1, id);
		prstmt.setString(2, "Hello");
		prstmt.setString(3, birth);
		System.out.println(prstmt.executeUpdate());
		prstmt.close();
				
	}
	
	
	//error
	public static void getCar(Connection conn, String manufacturer) throws SQLException {
		Statement prstmt = conn.createStatement(
				ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
		
		ResultSet rs = prstmt.executeQuery(""
				+ "SELECT * FROM CAR WHERE MANUFACTURER='Skoda'");
		List<Car> carList= new ArrayList<Car>();
		while(rs.next()) {
			rs.updateString("color", "hupilila");
			rs.updateRow();
			carList.add(new Car(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getInt(4)));	
		}
		
		for (Car car : carList) {
			System.out.println(car);
		}
	}
	
	public static void callableTest(Connection conn,double alpha) throws SQLException {
		CallableStatement cstmt = conn.prepareCall(
				"{?=call cos(?)}");
		cstmt.registerOutParameter(1, Types.NUMERIC);
		cstmt.setDouble(2, alpha);
		cstmt.execute();
		System.out.println(cstmt.getDouble(1));
		
	}
}