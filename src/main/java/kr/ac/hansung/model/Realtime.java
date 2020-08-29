package kr.ac.hansung.model;

import javax.persistence.Column;
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
	
	@Column(name="number_of_connections")
	private int numberOfConnections;
	
	@Column(name="accumulated_msg_size")
	private int accumulatedMsgSize;
	
	@Column(name="msg_publish_count")
	private int msgPublishCount;
	
	@Column(name="number_of_senders")
	private int numberOfSenders;

	@Override
	public String toString() {
		return "Realtime [date=" + date + ", numberOfConnections=" + numberOfConnections + ", accumulatedMsgSize="
				+ accumulatedMsgSize + ", msgPublishCount=" + msgPublishCount + "]";
	}
	
}
