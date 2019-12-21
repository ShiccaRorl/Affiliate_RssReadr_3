from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
 
 
Base = declarative_base()
 
 
class News(Base):
    
    __tablename__ = 'news'
 
    id = Column(Integer, primary_key=True)
    feedId = Column(Integer)
    title = Column(String)
    published = Column(DateTime)
    received = Column(DateTime)
    link_href = Column(String)
 
if __name__ == "__main__":
    engine = create_engine('sqlite:///RssData.SQLite3', echo=True)
    #Base.metadata.create_all(engine)  # テーブル作成


