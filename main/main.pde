import processing.serial.*;
import twitter4j.conf.*; 
import twitter4j.api.*; 
import twitter4j.*; 
import java.util.*; 

Serial armPort, pogoPort;
Integer centerOffset = 50;
Integer topOffset = 30;
Integer tpic = 0, bpic = 0;
Integer trumpOffsetX, trumpOffsetY, bernieOffsetX, bernieOffsetY;
PImage trump, t, bernie, b;
PImage trump1, trump2, trump3, trump4, trump5;
PImage bern1, bern2, bern3, bern4, bern5;
PImage title;
Integer value = 0, dlay = 1000;
Integer dimension = 400;
Integer trumpPoints = 0, berniePoints = 0;
PImage[] trumpReactions = new PImage[5];
PImage[] bernieReactions = new PImage[5];

Integer punchTrump = 0;
Integer punchBernie = 0;
Integer punchLimit = 4;
PFont f;

Integer bernieTweetNum = 0, trumpTweetNum = 0;
Integer tweetCount = 15; // until we find another query for anti bernie
String[] antiTrumpTweets = new String[tweetCount];
String[] antiBernieTweets = new String[tweetCount];
String displayedTweet = "";
ConfigurationBuilder cb; 
Query query; 
Twitter twitter;

void setup() {
  armPort = new Serial(this, Serial.list()[5], 9600);
  pogoPort = new Serial(this, Serial.list()[4], 9600);
  f = createFont("Georgia",40,true);
  textFont(f);
  
  fullScreen();
  //size(displayWidth, displayHeight);
  trumpOffsetX = displayWidth/2 - centerOffset - dimension/2;
  trumpOffsetY = 230 + topOffset + dimension/2;
  bernieOffsetX = displayWidth/2 + centerOffset + dimension/2;
  bernieOffsetY = 230 + topOffset + dimension/2;
  
  trump = loadImage("trump1.png");
  t = trump;
  trump1 = loadImage("trump2.png");
  trump2 = loadImage("trump3.png");
  trump3 = loadImage("trump4.png");
  trump4 = loadImage("trump5.png");
  trump5 = loadImage("trump6.png");
  bernie = loadImage("bernie1.png");
  b = bernie;
  bern1 = loadImage("bernie2.png");
  bern2 = loadImage("bernie3.png");
  bern3 = loadImage("bernie4.png");
  bern4 = loadImage("bernie5.png");
  bern5 = loadImage("bernie6.png");
  title = loadImage("title.jpg");
  
  trumpReactions[0] = trump1;
  trumpReactions[1] = trump2;
  trumpReactions[2] = trump3;
  trumpReactions[3] = trump4;
  trumpReactions[4] = trump5;
  bernieReactions[0] = bern1;
  bernieReactions[1] = bern2;
  bernieReactions[2] = bern3;
  bernieReactions[3] = bern4;
  bernieReactions[4] = bern5;
  
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("");   
  cb.setOAuthConsumerSecret("");   
  cb.setOAuthAccessToken("");   
  cb.setOAuthAccessTokenSecret("");
  
  twitter = new TwitterFactory(cb.build()).getInstance();    
  queryTwitter("trump");
  queryTwitter("bernie");
}

void queryTwitter(String candidate) {
  String hashtag = "";
  if (candidate == "trump") {
    hashtag = "#antitrump";
  } else if (candidate == "bernie") {
    hashtag = "#berniesucks";
  }
  Query query = new Query(hashtag);
  //query.setResultType(Query.POPULAR);
  query.setCount(tweetCount);
   
  try {
    QueryResult result = twitter.search(query);
    ArrayList tweets = (ArrayList) result.getTweets();
   
    for (int i = 0; i < tweets.size(); i++) {
      Status t = (Status) tweets.get(i);
      String user = t.getUser().getName();
      String msg = t.getText();
      Date d = t.getCreatedAt();
      String str = "Tweet by " + user + " at " + d + ": " + msg;
      println(str);
      if (candidate == "trump") {
        antiTrumpTweets[i] = str;
      } else if (candidate == "bernie") {
        antiBernieTweets[i] = str;
      }
    };
  }
  catch (TwitterException e) {
    println(e);
  };
}

void draw() {
  value = value + 1;
  if (value == 100) {
    t = trump;
    b = bernie;
    punchBernie = 0;
    punchTrump = 0;
  }
  background(255, 255, 255);
  imageMode(CORNER);
  image(title, int((displayWidth-780)/2), 50 + topOffset, 780, 130);
  
  textSize(40);
  // trump's points
  fill(255);
  stroke(255);
  rect(trumpOffsetX - dimension/2, 710, dimension, 50);
  fill(219, 41, 39);
  text(trumpPoints, trumpOffsetX, 750);
  
  // bernie's points
  fill(255);
  stroke(255);
  rect(bernieOffsetX - dimension/2, 710, dimension, 50);
  fill(39, 173, 221);
  text(berniePoints, bernieOffsetX, 750);
  
  imageMode(CENTER);
  fill(219, 41, 39);
  ellipse(trumpOffsetX, trumpOffsetY, dimension + 15*punchTrump, dimension + 15*punchTrump);
  fill(39, 173, 221);
  ellipse(bernieOffsetX, bernieOffsetY, dimension+15 + 15*punchBernie, dimension+15 + 15*punchBernie);
  image(t, trumpOffsetX, trumpOffsetY, dimension, dimension);
  image(b, bernieOffsetX, bernieOffsetY, dimension+15, dimension+15);
  noFill();
  stroke(0);
  ellipse(trumpOffsetX, trumpOffsetY, dimension + 15*punchLimit, dimension + 15*punchLimit);
  ellipse(bernieOffsetX, bernieOffsetY, dimension+15 + 15*punchLimit, dimension+15 + 15*punchLimit);
  
  // tweet
  fill(255);
  stroke(255);
  rect(50, 760, displayWidth-130, 100);
  fill(0, 85);
  textSize(16);
  text(displayedTweet, 100, 790, displayWidth-180, 100);
  
  // Read Serial Char
  int inByte = pogoPort.read();
  if (inByte == 'R') {
    punchTrump = punchTrump + 1;
    if (punchTrump > punchLimit) {
      berniePoints = berniePoints + 1;
      tpic = (tpic+1)%5;
      t = trumpReactions[tpic];
      armPort.write(inByte);
      delay(dlay);
      value = 0;
      punchTrump = punchTrump - 1;
    }
  }
  if (inByte == 'L') {
    punchBernie = punchBernie + 1;
    if (punchBernie > punchLimit) {
      trumpPoints = trumpPoints + 1;
      bpic = (bpic+1)%5;
      b = bernieReactions[bpic];
      armPort.write(inByte);
      delay(dlay);
      value = 0;
      punchBernie = punchBernie - 1;
    }
  }
}


void keyPressed() {
  // port.write(key);
  if (key == 'l') {
    punchTrump = punchTrump + 1;
    if (punchTrump > punchLimit) {
      berniePoints = berniePoints + 1;
      //armPort.write('L');
      tpic = (tpic+1)%5;
      t = trumpReactions[tpic];
      delay(dlay);
      value = 0;
      punchTrump = punchTrump - 1;
    }
  }
  if (key == 'r') {
    punchBernie = punchBernie + 1;
    if (punchBernie > punchLimit) {
      trumpPoints = trumpPoints + 1;
      //armPort.write('R');
      bpic = (bpic+1)%5;
      b = bernieReactions[bpic];
      delay(dlay);
      value = 0;
      punchBernie = punchBernie - 1;
    }
  }
}