import psycopg2
import tkinter as tk


"""
Note: It's essential never to include database credentials in code pushed to GitHub. 
Instead, sensitive information should be stored securely and accessed through environment variables or similar. 
However, in this particular exercise, we are allowing it for simplicity, as the focus is on a different aspect.
Remember to follow best practices for secure coding in production environments.
"""

# Acquire a connection to the database by specifying the credentials.
conn = psycopg2.connect(
    host="psql-dd1368-ht23.sys.kth.se", 
    database="",
    user="", 
    password="")
print(conn)

# Create a cursor. The cursor allows you to execute database queries.
cur = conn.cursor()

# Function to update the result text widget
def update_result_text(result):
    result_text.delete("1.0", tk.END)
    result_text.insert(tk.END, result)

# Simple function to get all books with a specific genre.
def get_book_title_by_genre():
    genre = genre_entry.get().strip()

    # Check if input is not empty or only whitespace
    if not genre.strip():
        update_result_text("Please enter a genre")
        return

    # Test injection 1: Horror'; INSERT INTO BOOKS (bookID,title,pages) VALUES (100000,'The Injection Book',666); --
    query = "SELECT books.title FROM books LEFT JOIN genre ON books.bookid = genre.bookid WHERE genre.genre = %s"  # Parameterized query
    cur.execute(query, (genre,))
    result = cur.fetchall()

    if len(result) < 1:
        update_result_text("There are no books in the genre: " + genre)
        return
    
    titles = [row[0] for row in result]
    
    result_str = "The following books are in the genre: " + genre + "\n"
    for title in titles:
        result_str += f"{title}\n"
    
    update_result_text(result_str)


def get_physical_books_related_to_title():
    title = title_entry.get().strip()
    
    if not title.strip():
        update_result_text("Please enter a title")
        return
    
    # query = f"SELECT resources.physicalid FROM resources LEFT JOIN books on resources.bookid = books.bookid WHERE books.title = '{title}'"
    # cur.execute(query)
    query = f"SELECT resources.physicalid FROM resources LEFT JOIN books on resources.bookid = books.bookid WHERE books.title = %s"
    cur.execute(query, (title,))
    result = cur.fetchall()
    if len(result) == 0:
        update_result_text("There are no physical copies for " + title)
        return
    
    copies = [row[0] for row in result]
    
    result_str = title + " has the following copies:\n"
    for id in copies:
        result_str += f"{id}\n"
    
    update_result_text(result_str)
    # print(copies)
    

# Function to get the number of copies available
def get_number_of_copies_available():
    query = f"WITH all_copies AS (SELECT title, COUNT(*) AS num_copies FROM books LEFT JOIN resources ON books.bookid = resources.bookid WHERE physicalid IS NOT NULL GROUP BY title, books.bookid), borrowed_copies AS (SELECT title, COUNT(*) AS num_copies_borrowed FROM books LEFT JOIN resources ON books.bookid = resources.bookid LEFT JOIN borrowing ON resources.physicalid = borrowing.physicalid WHERE borrowing.dor IS NULL GROUP BY title, books.bookid) SELECT books.title, books.bookid, COALESCE(SUM(all_copies.num_copies - borrowed_copies.num_copies_borrowed), 0) AS num_copies_available FROM books LEFT JOIN all_copies ON books.title = all_copies.title LEFT JOIN borrowed_copies ON books.title = borrowed_copies.title GROUP BY books.title, books.bookid ORDER BY title;;"
    cur.execute(query)
    result = cur.fetchall()
    titles_and_id_nums = [(row[0], row[1], int(row[2]) if row[2] is not None else 0) for row in result]

    result_str = ""
    for title, book_id, num in titles_and_id_nums:
        result_str += f"{title} ({book_id}): {num}\n"

    update_result_text(result_str)
    
def check_if_user_exists(email):
    # query = f"SELECT * FROM users WHERE email = '{email}'"
    # cur.execute(query)
    query = f"SELECT * FROM users WHERE email = %s"
    cur.execute(query, (email,))
    result = cur.fetchall()
    return len(result) > 0

def get_user_id(email):
    # query = f"SELECT userid FROM users WHERE email = '{email}'"
    # cur.execute(query)
    query = f"SELECT userid FROM users WHERE email = %s"
    cur.execute(query, (email,))
    result = cur.fetchall()
    return result[0][0]

# Function to borrow a book
def borrow_book():
    email = email_entry.get().strip()
    
    if not email.strip():
        update_result_text("Please enter a valid email")
        return
    
    # Check that email ends with @kth.se
    if not email.endswith("@kth.se"):
        update_result_text("Invalid email address")
        return
    if not check_if_user_exists(email):
        update_result_text("User does not exist")
        return
    
    user_id = get_user_id(email)

    # Check that the user has not borrowed more than 5 books
    # query = f"SELECT * FROM borrowing WHERE userid = {user_id} AND dor IS NULL"
    # cur.execute(query)
    query = f"SELECT * FROM borrowing WHERE userid = %s AND dor IS NULL"
    cur.execute(query, (user_id,))
    result = cur.fetchall()
    if len(result) >= 5:
        update_result_text("User has reached the limit of 4 borrowed books at once.\nYou have borrowed " + str(len(result)) + " books.\nPlease return a book before borrowing a new one.")
        return
    
    # Check that the user does not have any fines that are not paid
    # query = f"SELECT * FROM fines WHERE borrowingid IN (SELECT borrowingid FROM borrowing WHERE userid = {user_id}) AND borrowingid NOT IN (SELECT borrowingid FROM transactions);"
    # cur.execute(query)
    query = f"SELECT * FROM fines WHERE borrowingid IN (SELECT borrowingid FROM borrowing WHERE userid = %s) AND borrowingid NOT IN (SELECT borrowingid FROM transactions);"
    cur.execute(query, (user_id,))
    result = cur.fetchall()
    if len(result) > 0:
        update_result_text("You have unpaid fines. Please pay them before borrowing a new book.")
        return
    
    book_title = book_entry.get().strip()
    
    if not book_title.strip():
        update_result_text("Please enter a title")
        return
    
    # Check that the book exists
    # query = f"SELECT * FROM books WHERE title = '{book_title}'"
    # cur.execute(query)
    query = f"SELECT * FROM books WHERE title = %s"
    cur.execute(query, (book_title, ))
    result = cur.fetchall()
    if len(result) == 0:
        update_result_text("Book with the name: " + book_title + " does not exist")
        return
    elif len(result) > 1 and len(isbn_entry.get()) < 1:
        update_result_text("Multiple books with the same title exist. Please specify the ISBN")
        return
    
    if len(isbn_entry.get()) > 0:
        isbn = isbn_entry.get().strip()
        
        # Check that the isbn is valid
        if len(isbn) > 13 or not isbn.isdigit():
            update_result_text("Invalid ISBN. ISBN can be maximum 13 digits long and only contain numbers.")
            return
        
        # Check that the book exists
        # query = f"SELECT * FROM books WHERE bookid = {isbn} AND title = '{book_title}'"    
        # cur.execute(query)
        query = f"SELECT * FROM books WHERE bookid = %s AND title = %s"    
        cur.execute(query, (isbn, book_title))
        result = cur.fetchall()
        if len(result) == 0:
            update_result_text("Book with title: " + {book_title} + " and ISBN " + {isbn} + " does not exist")
            return
    else:
        # Get the isbn of the book
        # query = f"SELECT bookid FROM books WHERE title = '{book_title}'"
        # cur.execute(query)
        query = f"SELECT bookid FROM books WHERE title = %s"
        cur.execute(query, (book_title, ))
        result = cur.fetchall()
        isbn = result[0][0]
    
    
    # Check that the user has not already borrowed the book with the same bookid too many times
    # query = f"SELECT * FROM borrowing LEFT JOIN resources ON borrowing.physicalid = resources.physicalid LEFT JOIN books ON resources.bookid = books.bookid WHERE books.bookid = {isbn} AND borrowing.userid= {user_id} AND borrowing.dor IS NULL"
    # cur.execute(query)
    query = f"SELECT * FROM borrowing LEFT JOIN resources ON borrowing.physicalid = resources.physicalid LEFT JOIN books ON resources.bookid = books.bookid WHERE books.bookid = %s AND borrowing.userid= %s AND borrowing.dor IS NULL"
    cur.execute(query, (isbn, user_id))
    result = cur.fetchall()
    if len(result) >= 6:
        update_result_text("User has reached the limit of 6 borrows for this book")
        return
        
    # Check that the book is available
    # query = f"SELECT resources.physicalid FROM resources LEFT JOIN books on resources.bookid = books.bookid WHERE books.bookid = '{isbn}' AND resources.physicalid NOT IN (SELECT resources.physicalid FROM resources LEFT JOIN borrowing ON resources.physicalid = borrowing.physicalid WHERE borrowing.dor IS NULL);"    
    # cur.execute(query)
    query = f"SELECT resources.physicalid FROM resources LEFT JOIN books on resources.bookid = books.bookid WHERE books.bookid = %s AND resources.physicalid NOT IN (SELECT resources.physicalid FROM resources LEFT JOIN borrowing ON resources.physicalid = borrowing.physicalid WHERE borrowing.dor IS NULL);"    
    cur.execute(query, (isbn,))
    result = cur.fetchall()
    if len(result) == 0:
        update_result_text("Book " + book_title + " (" + isbn + ") is not available")
        return
    elif len(result) > 0:
        # Get a physical id that is available
        physical_id_to_borrow = result[0][0]
    
    # Get max borrowing id
    query = f"SELECT MAX(borrowingid) FROM borrowing"
    cur.execute(query)
    result = cur.fetchall()
    borrowing_id = result[0][0] + 1
    
    # Get current date
    # current_date = datetime.datetime.now().date()
    # current_date_str = current_date.strftime("%Y-%m-%d")
    
    # Insert a new row into the borrowing table
    # query = f"INSERT INTO borrowing (borrowingid, userid, physicalid) VALUES ({borrowing_id}, {user_id}, {physical_id_to_borrow})"
    # cur.execute(query)
    query = f"INSERT INTO borrowing (borrowingid, userid, physicalid) VALUES (%s, %s, %s)"
    cur.execute(query, (borrowing_id, user_id, physical_id_to_borrow))
    # Catch errors
    try:
        conn.commit()
    except:
        conn.rollback()
        update_result_text("Something went wrong")
        return
    
    # Get the due date for the book that we inserted
    # query = f"SELECT doe FROM borrowing WHERE borrowingid = {borrowing_id}"
    # cur.execute(query)
    query = f"SELECT doe FROM borrowing WHERE borrowingid = %s"
    cur.execute(query, (borrowing_id,))
    result = cur.fetchall()
    due_date = result[0][0]
    
    update_result_text(book_title + " was borrowed successfully. It must be returned by " + str(due_date)) 
    


if __name__ == "__main__":
    
    # Create tkinter window
    window = tk.Tk()
    window.title("Bibblan")
    window.geometry("1000x600")

    # Create a label
    label = tk.Label(text="Welcome to the library!")
    label.grid(column=0, row=0)

    # Create a button for getting all books with a specific genre
    button1 = tk.Button(text="Get all books with a specific genre", command=get_book_title_by_genre)
    button1.place(x=0, y=50)
    
    # Create an entry widget for the genre
    genre_entry = tk.Entry(window, width=30)
    genre_entry.place(x=0, y=80)
    
    # Create a button for getting all physical books related to a title
    button2 = tk.Button(text="Get all physical books related to a title", command=get_physical_books_related_to_title)
    button2.place(x=0, y=140)
    
    # Create an entry widget for the title
    title_entry = tk.Entry(window, width=30)
    title_entry.place(x=0, y=170)
    
    # Create a text widget to display the result
    result_text = tk.Text(window, height=43, width=70)
    result_text.place(x=500, y=10)
    
    # Create a button for getting the number of copies available
    button3 = tk.Button(text="Get the number of copies available", command=get_number_of_copies_available)
    button3.place(x=0, y=230)

    
    # Create input fields for the borrowing process
    email_label = tk.Label(text="E-mail:")
    email_label.place(x=0, y=290)
    email_entry = tk.Entry(window, width=30)
    email_entry.place(x=0, y=310)

    book_label = tk.Label(text="Name of the book you want to borrow:")
    book_label.place(x=0, y=340)
    book_entry = tk.Entry(window, width=30)
    book_entry.place(x=0, y=370)

    isbn_label = tk.Label(text="ISBN (optional):")
    isbn_label.place(x=0, y=400)
    isbn_entry = tk.Entry(window, width=30)
    isbn_entry.place(x=0, y=430)
    
    # Create a button for borrowing a book
    button4 = tk.Button(text="Borrow", command=borrow_book)
    button4.place(x=0, y=460)
    
    window.mainloop()

    # Example:
    # Execute a query which returns all genres including the genre id.
    # cur.execute("SELECT * from genre ")

    # # Print the first row returned.
    # print(cur.fetchone())
    
    # # Print the next row returned.
    # print(cur.fetchone())
    
    # # Print all the remaining rows returned.
    # print(cur.fetchall())

    # get_book_title_by_genre()
    
    # get_physical_books_related_to_title()

    # get_number_of_copies_available()
    
    # Close the connection to the database.
    conn.close()
    
    
# Get the physical id of a book with a specific title that is available
