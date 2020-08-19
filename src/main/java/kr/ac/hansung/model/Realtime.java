package kr.ac.hansung.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@Entity
@Table(name="realtime")
public class Realtime {
	
	@Id
	private String date;
	
	private int number_of_connections;
	
	private int accumulated_msg_size;
	
	private int number_of_msgs;

	@Override
	public String toString() {
		return "Realtime [date=" + date + ", number_of_connections=" + number_of_connections + ", accumulated_msg_size="
				+ accumulated_msg_size + ", number_of_msgs=" + number_of_msgs + "]";
	}
	
}
