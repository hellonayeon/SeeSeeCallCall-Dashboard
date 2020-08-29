package kr.ac.hansung.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name="topic")
public class Topic {

	@Id
	private String topic;
	
	@Column(name="msg_publish_count")
	private int msgPublishCount;
	
	@Column(name="accumulated_msg_size")
	private int accumulatedMsgSize;
	
	@Column(name="start_date")
	private String startDate;
	
	@Column(name="participants")
	private int participants;
	
	@OneToMany(mappedBy="topic", cascade=CascadeType.ALL, fetch=FetchType.EAGER)
	private List<Client> clients = new ArrayList<Client>();

	@Override
	public String toString() {
		return "Topic [topic=" + topic + ", msgPublishCount=" + msgPublishCount + ", accumulatedMsgSize="
				+ accumulatedMsgSize + ", startDate=" + startDate + ", participants=" + participants + ", clients="
				+ clients + "]";
	}
	
	
}
