import sys
import datetime

def process_line(line):
    try:
        # Split the line and extract timestamp
        parts = line.split(':')
        
        # Check if the line has the expected number of parts
        if len(parts) < 2:
            raise ValueError("Invalid line format")

        timestamp = int(parts[1])
        
        # Convert Unix timestamp to a datetime object
        dt_object = datetime.datetime.fromtimestamp(timestamp)
        
        # Format the datetime object as desired
        formatted_timestamp = dt_object.strftime("%Y/%m/%d %H:%M")
        
        # Return the processed line
        return f"{formatted_timestamp} - {line}"

    except (IndexError, ValueError) as e:
        # Handle errors in case the line doesn't follow the expected format
        return f"Error processing line: {line} - {e}"

def main():
    # Check if the correct number of command-line arguments is provided
    if len(sys.argv) != 2:
        print("Usage: python3 myscript.py <input_file>")
        sys.exit(1)

    input_file_path = sys.argv[1]

    # Output file path (you can customize this)
    output_file_path = "processed_output.txt"

    try:
        with open(input_file_path, 'r') as input_file, open(output_file_path, 'w') as output_file:
            for line in input_file:
                processed_line = process_line(line.strip())
                output_file.write(processed_line + '\n')
        
        print(f"Processing complete. Output written to {output_file_path}")

    except FileNotFoundError:
        print(f"Error: File not found - {input_file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()


# https://docs.python.org/3/library/sys.html#sys.argv

# ABOUT == mock atm