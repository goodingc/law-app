import 'package:flutter/material.dart';
import 'package:law_app/models/commercial_awareness/event.dart';

import '../comms.dart';
import '../../models/commercial_awareness/event_brief.dart';

class CommercialAwarenessEventsProvider extends ChangeNotifier {
  CommsProvider comms;

  List<CommercialAwarenessEventBrief> eventBriefs = [];

  CommercialAwarenessEventsProvider() {
    cloneBriefs();
  }

  CommercialAwarenessEvent getEvent(int id) {
    return CommercialAwarenessEvent(
        id: id,
        title: 'Commercial Awareness Event $id',
        timestamp: DateTime.now().subtract(Duration(days: id)),
        caption: 'Lorem ipsum dolor sit amet, consectetur adipiscing '
            'elit. Sed pharetra tortor metus, pharetra dignissim '
            'ligula aliquam vel. Sed at imperdiet dui, sed '
            'dapibus eros.',
        imageUrl:
            'https://via.placeholder.com/400x200?text=image for event $id',
        content: _markdownData);
  }

  void cloneBriefs() async {
    eventBriefs = [
      for (int i = 0; i < 10; i++)
        CommercialAwarenessEventBrief(
            id: i,
            title: 'Commercial Awareness Event $i',
            timestamp: DateTime.now().subtract(Duration(days: i)),
            caption: 'Lorem ipsum dolor sit amet, consectetur adipiscing '
                'elit. Sed pharetra tortor metus, pharetra dignissim '
                'ligula aliquam vel. Sed at imperdiet dui, sed '
                'dapibus eros. Maecenas et quam in velit mollis '
                'mattis. Quisque accumsan ante et lacus accumsan '
                'dignissim. Duis malesuada nibh in convallis '
                'consectetur. Aenean porta dapibus suscipit. '
                'Aliquam luctus sollicitudin pretium.',
            imageUrl:
                'https://via.placeholder.com/400x200?text=image for event $i'),
    ];
    notifyListeners();
  }

  void pullBriefs() async {
    eventBriefs = eventBriefs.reversed.toList();
    notifyListeners();
  }
}

const String _markdownData = """
# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app.

## Titles

Setext-style

```
This is an H1
=============

This is an H2
-------------
```

This is an H1
=============

This is an H2
-------------

Atx-style

```
# This is an H1

## This is an H2

###### This is an H6
```

# This is an H1

## This is an H2

###### This is an H6

Select the valid headers:

- [x] `# hello`
- [ ] `#hello`

## Links

[Google's Homepage][Google]

```
[inline-style](https://www.google.com)

[reference-style][Google]
```

## Images

![Flutter logo](/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)

## Tables

|Syntax                                 |Result                               |
|---------------------------------------|-------------------------------------|
|`*italic 1*`                           |*italic 1*                           |
|`_italic 2_`                           | _italic 2_                          |
|`**bold 1**`                           |**bold 1**                           |
|`__bold 2__`                           |__bold 2__                           |
|`This is a ~~strikethrough~~`          |This is a ~~strikethrough~~          |
|`***italic bold 1***`                  |***italic bold 1***                  |
|`___italic bold 2___`                  |___italic bold 2___                  |
|`***~~italic bold strikethrough 1~~***`|***~~italic bold strikethrough 1~~***|
|`~~***italic bold strikethrough 2***~~`|~~***italic bold strikethrough 2***~~|

## Styling
Style text as _italic_, __bold__, ~~strikethrough~~, or `inline code`.

- Use bulleted lists
- To better clarify
- Your points

## Code blocks
Formatted Dart code looks really pretty too:

```
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Markdown(data: markdownData),
    ),
  ));
}
```

## Markdown widget

This is an example of how to create your own Markdown widget:

    Markdown(data: 'Hello _world_!');

Enjoy!

[Google]: https://www.google.com/

## Line Breaks

This is an example of how to create line breaks (tab or two whitespaces):

line 1
  
   
line 2
  
  
  
line 3
""";