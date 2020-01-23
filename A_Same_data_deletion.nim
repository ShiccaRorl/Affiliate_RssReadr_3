import norm/sqlite
import unicode, sugar, options
import times

db("C:/Affiliate_RssReadr_3/RssData.SQLite3", "", "", ""):             # Set DB connection credentials.
  type                                    # Describe object model in an ordinary type section.
    News = object
        id: Positive                       # Nim types are automatically converted into SQL types
        feedId: int                                  # and back.
        title: string                                 # You can specify how types are converted using
        published: datetime                                 # ``parser``, ``formatter``, ``parseIt``,
        received: Datetime                                  # and ``formatIt`` pragmas.
        link_href: string


proc del():
    echo "test"













