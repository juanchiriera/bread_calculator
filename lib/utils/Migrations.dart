final CREATE_DB = ['''
          CREATE TABLE recipees (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
          )
        ''',
        '''
          CREATE TABLE ingredients (
            id INTEGER PRIMARY KEY,
            idRecipee INTEGER,
            name TEXT NOT NULL,
            quantity DOUBLE NOT NULL,
            FOREIGN KEY (idRecipee) REFERENCES recipees(id)
          )
        '''];

final MIGRATIONS = [];