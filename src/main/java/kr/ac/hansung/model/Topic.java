package kr.ac.hansung.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
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
	
	private int msg_sending_count;
	
	private int accumulated_msg_size;
	
	private String start_date;
	
	private String finish_date;
	
	private int participants;
	
	@OneToMany(mappedBy="topic", cascade=CascadeType.ALL, fetch=FetchType.EAGER)
	private List<Client> clients = new ArrayList<Client>();

	@Override
	public String toString() {
		return "Topic [topic=" + topic + ", msg_sending_count=" + msg_sending_count + ", accumulated_msg_size="
				+ accumulated_msg_size + ", start_date=" + start_date + ", finish_date=" + finish_date
				+ ", participants=" + participants + ", clients=" + clients + "]";
	}	
	
}
