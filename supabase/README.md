# Supabase Database Setup for Womb Wisdom Wellbeing App

This directory contains SQL scripts for setting up the necessary database tables and functions in Supabase for the Womb Wisdom Wellbeing App.

## Community Posts Table Setup

The `setup_community_posts_table.sql` script creates a SQL function that will:

1. Create the `community_posts` table if it doesn't exist
2. Set up Row Level Security (RLS) policies to ensure data security
3. Create appropriate indexes for better query performance

### How to Use

1. Log in to your Supabase dashboard
2. Navigate to the SQL Editor
3. Copy the contents of `setup_community_posts_table.sql`
4. Paste into the SQL Editor and run the script
5. This will create the `create_community_posts_table()` function
6. The app will automatically call this function when initializing

### Table Structure

The `community_posts` table includes the following fields:

- `id`: UUID primary key
- `user_id`: UUID foreign key to auth.users
- `username`: Text field for the post creator's username
- `title`: Text field for the post title
- `content`: Text field for the post content
- `tags`: Array of text tags
- `created_at`: Timestamp of post creation
- `likes`: Integer count of likes
- `comments`: Integer count of comments
- `post_type`: Text field with check constraint ('discussion', 'group', 'event')
- `date`: Text field for event date (for event posts)
- `time`: Text field for event time (for event posts)
- `location`: Text field for location (for event/group posts)
- `attendees`: Integer count of attendees (for event posts)
- `members`: Integer count of members (for group posts)
- `image_url`: Text field for optional image URL

### Row Level Security

The script sets up the following security policies:

- All authenticated users can read all posts
- Users can only create, update, or delete their own posts

## Troubleshooting

If you encounter errors related to the community posts table:

1. Check if the SQL function was properly created in Supabase
2. Verify that your Supabase credentials are correct in the app
3. Ensure you have the necessary permissions to create tables and functions
4. Check the app logs for specific error messages

For any issues, please refer to the Supabase documentation or contact the development team.
