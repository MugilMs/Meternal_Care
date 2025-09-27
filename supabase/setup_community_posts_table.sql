-- Function to create the community_posts table if it doesn't exist
CREATE OR REPLACE FUNCTION create_community_posts_table()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if the table already exists
  IF NOT EXISTS (
    SELECT FROM pg_tables
    WHERE schemaname = 'public'
    AND tablename = 'community_posts'
  ) THEN
    -- Create the community_posts table
    CREATE TABLE public.community_posts (
      id UUID PRIMARY KEY,
      user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
      username TEXT NOT NULL,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      tags TEXT[] NOT NULL,
      created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
      likes INTEGER NOT NULL DEFAULT 0,
      comments INTEGER NOT NULL DEFAULT 0,
      post_type TEXT NOT NULL CHECK (post_type IN ('discussion', 'group', 'event')),
      date TEXT,
      time TEXT,
      location TEXT,
      attendees INTEGER,
      members INTEGER,
      image_url TEXT
    );

    -- Set up RLS (Row Level Security)
    ALTER TABLE public.community_posts ENABLE ROW LEVEL SECURITY;

    -- Create policy for authenticated users to read all posts
    CREATE POLICY "Authenticated users can read all posts"
      ON public.community_posts
      FOR SELECT
      TO authenticated
      USING (true);

    -- Create policy for users to create their own posts
    CREATE POLICY "Users can create their own posts"
      ON public.community_posts
      FOR INSERT
      TO authenticated
      WITH CHECK (auth.uid() = user_id);

    -- Create policy for users to update their own posts
    CREATE POLICY "Users can update their own posts"
      ON public.community_posts
      FOR UPDATE
      TO authenticated
      USING (auth.uid() = user_id)
      WITH CHECK (auth.uid() = user_id);

    -- Create policy for users to delete their own posts
    CREATE POLICY "Users can delete their own posts"
      ON public.community_posts
      FOR DELETE
      TO authenticated
      USING (auth.uid() = user_id);

    -- Create index on post_type for faster filtering
    CREATE INDEX idx_community_posts_post_type ON public.community_posts(post_type);
    
    -- Create index on user_id for faster user-specific queries
    CREATE INDEX idx_community_posts_user_id ON public.community_posts(user_id);
    
    -- Create index on created_at for faster sorting
    CREATE INDEX idx_community_posts_created_at ON public.community_posts(created_at);

    RAISE NOTICE 'Created community_posts table with RLS policies';
  ELSE
    RAISE NOTICE 'community_posts table already exists';
  END IF;
END;
$$;
