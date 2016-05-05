package edu.neu.cs5500.Jerks.apiCall;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
//import java.util.Scanner;


import org.json.*;

import edu.neu.cs5500.Jerks.definitions.*;

/*
@Auth: Karthik
	this class should be used to obtain event lists from the the given set of criteria.
	the input would be in form of a formed URL which will return JSON from EventBrite REST apis
	which is then parsed to obtain the Event object.
	CURRENTLY, event object is not described hence just parsing for the title text of each event */

public class EventfulAPICall {
	
	private static String getJsontext(String url) throws IOException
	{
		URL neturl = new URL(url);
		BufferedReader br = new BufferedReader(new InputStreamReader(neturl.openStream()));
		String jsontext = "";
		String temp;
		while((temp=br.readLine())!=null)
			jsontext = jsontext.concat(temp);
		br.close();
		return jsontext;
	}
	
	public ArrayList<Event> getListofEventsFromJSON(String url) throws IOException, JSONException, ParseException
	{
		System.out.println(url);
		ArrayList<Event> LoEvents = new ArrayList<Event>();		
		String jsontext = getJsontext(url);
		//creating jsonobject from text
		JSONObject json = new JSONObject(jsontext);
		int total_items = Integer.parseInt(json.get("total_items").toString());
		if (total_items > 0) {
			org.json.JSONArray listings = json.getJSONObject("events").getJSONArray("event"); 
			int maxLoopCount = Math.min(listings.length(), 50);
			for (int i = 0; i < maxLoopCount; i++) // for every event in the array, retrieving the required materials.
			{
				JSONObject iterateObj = listings.getJSONObject(i);
				Event event = new Event();
				event.setEventId(iterateObj.get("id").toString());
				event.setName(iterateObj.get("title").toString());
				if (iterateObj.get("description").toString() == "null")
					event.setDescription(event.getName());
				else
					event.setDescription(iterateObj.get("description").toString());
				Date date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(iterateObj.get("start_time").toString());
				event.setDate(date);
				event.setSource(EventSource.EventFul);

				Address address = new Address();
				address.setAddressLine1(iterateObj.get("venue_name").toString());
				address.setAddressLine2(iterateObj.get("venue_address").toString());
				address.setCity(iterateObj.get("city_name").toString());
				address.setState(iterateObj.get("region_name").toString());
				address.setCountry(iterateObj.get("country_name").toString());
				address.setZipCode(iterateObj.get("postal_code").toString());
				if(iterateObj.get("latitude").toString() != null && iterateObj.get("latitude").toString() !=""){
					address.setLatitude(Float.parseFloat(iterateObj.get("latitude").toString()));
				}
				if(iterateObj.get("longitude").toString() != null && iterateObj.get("longitude").toString() !=""){
					address.setLongitude(Float.parseFloat(iterateObj.get("longitude").toString()));
				}
				event.setAddress(address);
				LoEvents.add(event);				
			}
		}
		return LoEvents;
	}

}