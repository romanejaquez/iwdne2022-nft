import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static const Color bgColor = Color(0xFFF5F5F5);
  static const Color blue = Color(0xFF53A4E8);
  static const Color purple = Color(0xFF7E8AF4);
  static const Color green = Color(0xFF41C6DA);
  static const Color darkColor = Color(0xFF424242);

  static void launchUrl(String url) async {
    await launch(url);
  }

  static List<BackgroundTemplate> getTemplateList() {
    return [
      BackgroundTemplate(
          thumbName: 'thumb1',
          imgName: 'template1',
          isSelected: true,
          color: Utils.darkColor),
      BackgroundTemplate(
          thumbName: 'thumb2',
          imgName: 'template2',
          isSelected: false,
          color: Utils.darkColor),
      BackgroundTemplate(
          thumbName: 'thumb3',
          imgName: 'template3',
          isSelected: false,
          color: Colors.white),
      BackgroundTemplate(
          thumbName: 'thumb4',
          imgName: 'template4',
          isSelected: false,
          color: Utils.blue)
    ];
  }

  static List<DefaultQuote> getDefaultQuotes() {
    return [
      DefaultQuote(
          phrase:
              "When we do the best we can, we never know what miracle is wrought in our life, or in the life of another.",
          author: "Helen Keller"),
      DefaultQuote(
          phrase:
              "Any woman who understands the problems of running a home will be nearer to understanding the problems of running a country.",
          author: "Margaret Thatcher"),
      DefaultQuote(
          phrase: "If you obey all the rules, you miss all the fun.",
          author: "Katharine Hepburn"),
      DefaultQuote(
          phrase:
              "Life is not measured by the number of breaths we take, but by the moments that take our breath away.",
          author: "Maya Angelou"),
      DefaultQuote(
          phrase: "Life shrinks or expands in proportion to one’s courage.",
          author: "Anais Nin"),
      DefaultQuote(
          phrase: "If you don’t like being a doormat then get off the floor.",
          author: "Al Anon"),
      DefaultQuote(
          phrase:
              "A lot of people are afraid to say what they want. That’s why they don’t get what they want.",
          author: "Madonna"),
      DefaultQuote(
          phrase:
              "A woman is like a tea bag – you never know how strong she is until she gets in hot water.",
          author: "Eleanor Roosevelt"),
      DefaultQuote(
          phrase:
              "I know God will not give me anything I can’t handle. I just wish that He didn’t trust me so much.",
          author: "Mother Teresa"),
      DefaultQuote(
          phrase:
              "A woman is the full circle. Within her is the power to create, nurture and transform.",
          author: "Diane Mariechild"),
      DefaultQuote(
          phrase: "The best protection any woman can have … is courage.",
          author: "Elizabeth Cady Stanton"),
      DefaultQuote(
          phrase:
              "We must believe that we are gifted for something, and that this thing, at whatever cost, must be attained.",
          author: "Marie Curie"),
      DefaultQuote(
          phrase: "Success breeds confidence.", author: "Beryl Markham"),
      DefaultQuote(
          phrase:
              "The question isn’t who’s going to let me; it’s who is going to stop me.",
          author: "Ayn Rand"),
      DefaultQuote(
          phrase:
              "If you look at what you have in life, you’ll always have more. If you look at what you don’t have in life, you’ll never have enough.",
          author: "Oprah Winfrey"),
      DefaultQuote(
          phrase:
              "Whatever women do they must do twice as well as men to be thought half as good. Luckily, this is not difficult.",
          author: "Charlotte Whitton"),
      DefaultQuote(
          phrase:
              "The most common way people give up their power is by thinking they don’t have any.",
          author: "Alice Walker"),
      DefaultQuote(
          phrase:
              "One likes people much better when they’re battered down by a prodigious siege of misfortune than when they triumph.",
          author: "Virginia Woolf"),
      DefaultQuote(
          phrase:
              "Women are never stronger than when they arm themselves with their weaknesses.",
          author: "Madame Marie du Deffand"),
      DefaultQuote(
          phrase:
              "When you lose a couple of times, it makes you realize how difficult it is to win.",
          author: "Steffi Graf"),
      DefaultQuote(
          phrase:
              "You take your life in your own hands, and what happens? A terrible thing, no one to blame.",
          author: "Erica Jong"),
      DefaultQuote(
          phrase:
              "You move totally away from reality when you believe that there is a legitimate reason to suffer.",
          author: "Byron Katie"),
      DefaultQuote(
          phrase: "Courage is like a muscle. We strengthen it by use.",
          author: "Ruth Gordon"),
      DefaultQuote(
          phrase:
              "Always go with the choice that scares you the most, because that’s the one that is going to require the most from you.",
          author: "Caroline Myss"),
      DefaultQuote(
          phrase: "Stop wearing your wishbone where your backbone ought to be.",
          author: "Elizabeth Gilbert"),
      DefaultQuote(
          phrase: "Taking joy in living is a woman’s best cosmetic.",
          author: "Rosalind Russell"),
      DefaultQuote(
          phrase:
              "A woman with a voice is by definition a strong woman. But the search to find that voice can be remarkably difficult.",
          author: "Melinda Gates"),
      DefaultQuote(
          phrase:
              "A man’s got to do what a man’s got to do. A woman must do what he can’t.",
          author: "Rhonda Hansome"),
      DefaultQuote(
          phrase:
              "You have to have confidence in your ability, and then be tough enough to follow through.",
          author: "Rosalynn Carter")
    ];
  }
}

class BackgroundTemplate {
  String? imgName;
  String? thumbName;
  bool? isSelected;
  Color? color;

  BackgroundTemplate(
      {this.thumbName, this.imgName, this.isSelected, this.color});
}

class DefaultQuote {
  String? phrase;
  String? author;
  bool? isSelected;

  DefaultQuote({this.phrase, this.author, this.isSelected = false });
}
