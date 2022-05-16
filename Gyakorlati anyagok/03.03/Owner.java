package model;

import java.sql.Date;

public class Owner {
	private int id;
	private String name;
	private Date birth;
	
	public int getId(){
		return id;
	}
	
	public void setId(int id){
		this.id = id;
		}
	public String getName() {
		this.name = name;
	}
		
	public void setName(String name){
		this.name = name;
	}
	
	public Date getBirth(Date birth){
		this.birth = birth;
	}
	
	public Owner(int id, String name, Date birth){
		super();
		this.id = id;
		this.name = name;
		this.birth = birth;
	}
}