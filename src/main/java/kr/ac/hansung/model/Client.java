package kr.ac.hansung.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name="client")
public class Client implements Serializable {

	private static final long serialVersionUID = -7703220878208784683L;

	@Id
	private String name;
	
	@Column(name="msg_publish_count")
	private int msgPublishCount; 
	
	@Column(name="accumulated_msg_size")
	private int accumulatedMsgSize;
	
	@Column(name="platform")
	private String platform;
	
	@Id
	@Column(name="topic")
	private String topic;

	@Override
	public String toString() {
		return "Client [name=" + name + ", msgPublishCount=" + msgPublishCount + ", accumulatedMsgSize="
				+ accumulatedMsgSize + ", platform=" + platform + ", topic=" + topic + "]";
	}

}
