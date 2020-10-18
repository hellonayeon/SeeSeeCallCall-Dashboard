package kr.ac.hansung.model;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name="component")
public class Component implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private int stroke;
	
	private int rect;
	
	private int oval;
	
	private int text;
	
	private int image;
	
	@Id
    @JoinColumn(name = "topic")
	private String topic;

	
	@Override
	public String toString() {
		return "Component [stroke=" + stroke + ", rect=" + rect + ", oval=" + oval + ", text=" + text + ", topic="
				+ topic + "]";
	}
	
	
}
