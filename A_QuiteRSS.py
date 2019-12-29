from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
 
 
Base = declarative_base()


class QuiteRSS(Base):

    __tablename__ = 'news'
 
    id = Column(Integer, primary_key=True)
    feedId = Column(Integer)
    title = Column(String)
    published = Column(String)
    received = Column(String)
    link_href = Column(String)
 
if __name__ == "__main__":
    engine = create_engine('sqlite:///C:/Users/ban/AppData/Local/QuiteRss/QuiteRss/feeds.db', echo=True)
    #Base.metadata.create_all(engine)  # テーブル作成
