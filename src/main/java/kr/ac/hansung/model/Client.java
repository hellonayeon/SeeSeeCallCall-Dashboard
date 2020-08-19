package kr.ac.hansung.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Entity
@Table(name="client")
public class Client implements Serializable {

	private static final long serialVersionUID = -7703220878208784683L;

	@Id
	private String name;
	
	private int msg_sending_count; 
	
	private int accumulated_msg_size;
	
	private String platform;
	
	@Id
	private String topic;

	@Override
	public String toString() {
		return "Client [name=" + name + ", msg_sending_count=" + msg_sending_count + ", accumulated_msg_size="
				+ accumulated_msg_size + ", platform=" + platform + ", topic=" + topic + "]";
	}
	
}
