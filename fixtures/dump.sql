PGDMP     %        	            v            mastodon_development    10.2    10.2 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           1262    195845    mastodon_development    DATABASE     �   CREATE DATABASE mastodon_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
 $   DROP DATABASE mastodon_development;
             nolan    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             nolan    false                        0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  nolan    false    3                        3079    12544    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false                       0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                       1255    195846    timestamp_id(text)    FUNCTION     Y  CREATE FUNCTION timestamp_id(table_name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
  DECLARE
    time_part bigint;
    sequence_base bigint;
    tail bigint;
  BEGIN
    time_part := (
      -- Get the time in milliseconds
      ((date_part('epoch', now()) * 1000))::bigint
      -- And shift it over two bytes
      << 16);

    sequence_base := (
      'x' ||
      -- Take the first two bytes (four hex characters)
      substr(
        -- Of the MD5 hash of the data we documented
        md5(table_name ||
          '41569431c71b583685001be129fe54b0' ||
          time_part::text
        ),
        1, 4
      )
    -- And turn it into a bigint
    )::bit(16)::bigint;

    -- Finally, add our sequence number to our base, and chop
    -- it to the last two bytes
    tail := (
      (sequence_base + nextval(table_name || '_id_seq'))
      & 65535);

    -- Return the time part and the sequence part. OR appears
    -- faster here than addition, but they're equivalent:
    -- time_part has no trailing two bytes, and tail is only
    -- the last two bytes.
    RETURN time_part | tail;
  END
$$;
 4   DROP FUNCTION public.timestamp_id(table_name text);
       public       nolan    false    1    3            �            1259    195847    account_domain_blocks    TABLE     �   CREATE TABLE account_domain_blocks (
    id bigint NOT NULL,
    domain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
 )   DROP TABLE public.account_domain_blocks;
       public         nolan    false    3            �            1259    195853    account_domain_blocks_id_seq    SEQUENCE     ~   CREATE SEQUENCE account_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.account_domain_blocks_id_seq;
       public       nolan    false    3    196                       0    0    account_domain_blocks_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE account_domain_blocks_id_seq OWNED BY account_domain_blocks.id;
            public       nolan    false    197            �            1259    195855    account_moderation_notes    TABLE       CREATE TABLE account_moderation_notes (
    id bigint NOT NULL,
    content text NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 ,   DROP TABLE public.account_moderation_notes;
       public         nolan    false    3            �            1259    195861    account_moderation_notes_id_seq    SEQUENCE     �   CREATE SEQUENCE account_moderation_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.account_moderation_notes_id_seq;
       public       nolan    false    3    198                       0    0    account_moderation_notes_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE account_moderation_notes_id_seq OWNED BY account_moderation_notes.id;
            public       nolan    false    199            �            1259    195863    accounts    TABLE       CREATE TABLE accounts (
    id bigint NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    secret character varying DEFAULT ''::character varying NOT NULL,
    private_key text,
    public_key text DEFAULT ''::text NOT NULL,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    salmon_url character varying DEFAULT ''::character varying NOT NULL,
    hub_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    display_name character varying DEFAULT ''::character varying NOT NULL,
    uri character varying DEFAULT ''::character varying NOT NULL,
    url character varying,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    header_file_name character varying,
    header_content_type character varying,
    header_file_size integer,
    header_updated_at timestamp without time zone,
    avatar_remote_url character varying,
    subscription_expires_at timestamp without time zone,
    silenced boolean DEFAULT false NOT NULL,
    suspended boolean DEFAULT false NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    header_remote_url character varying DEFAULT ''::character varying NOT NULL,
    statuses_count integer DEFAULT 0 NOT NULL,
    followers_count integer DEFAULT 0 NOT NULL,
    following_count integer DEFAULT 0 NOT NULL,
    last_webfingered_at timestamp without time zone,
    inbox_url character varying DEFAULT ''::character varying NOT NULL,
    outbox_url character varying DEFAULT ''::character varying NOT NULL,
    shared_inbox_url character varying DEFAULT ''::character varying NOT NULL,
    followers_url character varying DEFAULT ''::character varying NOT NULL,
    protocol integer DEFAULT 0 NOT NULL,
    memorial boolean DEFAULT false NOT NULL,
    moved_to_account_id bigint
);
    DROP TABLE public.accounts;
       public         nolan    false    3            �            1259    195891    accounts_id_seq    SEQUENCE     q   CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.accounts_id_seq;
       public       nolan    false    200    3                       0    0    accounts_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;
            public       nolan    false    201            �            1259    195893    admin_action_logs    TABLE     o  CREATE TABLE admin_action_logs (
    id bigint NOT NULL,
    account_id bigint,
    action character varying DEFAULT ''::character varying NOT NULL,
    target_type character varying,
    target_id bigint,
    recorded_changes text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 %   DROP TABLE public.admin_action_logs;
       public         nolan    false    3            �            1259    195901    admin_action_logs_id_seq    SEQUENCE     z   CREATE SEQUENCE admin_action_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.admin_action_logs_id_seq;
       public       nolan    false    202    3                       0    0    admin_action_logs_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE admin_action_logs_id_seq OWNED BY admin_action_logs.id;
            public       nolan    false    203            �            1259    195903    ar_internal_metadata    TABLE     �   CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         nolan    false    3            �            1259    195909    blocks    TABLE     �   CREATE TABLE blocks (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.blocks;
       public         nolan    false    3            �            1259    195912    blocks_id_seq    SEQUENCE     o   CREATE SEQUENCE blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.blocks_id_seq;
       public       nolan    false    3    205                       0    0    blocks_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE blocks_id_seq OWNED BY blocks.id;
            public       nolan    false    206            �            1259    195914    conversation_mutes    TABLE     �   CREATE TABLE conversation_mutes (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    account_id bigint NOT NULL
);
 &   DROP TABLE public.conversation_mutes;
       public         nolan    false    3            �            1259    195917    conversation_mutes_id_seq    SEQUENCE     {   CREATE SEQUENCE conversation_mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.conversation_mutes_id_seq;
       public       nolan    false    207    3                       0    0    conversation_mutes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE conversation_mutes_id_seq OWNED BY conversation_mutes.id;
            public       nolan    false    208            �            1259    195919    conversations    TABLE     �   CREATE TABLE conversations (
    id bigint NOT NULL,
    uri character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.conversations;
       public         nolan    false    3            �            1259    195925    conversations_id_seq    SEQUENCE     v   CREATE SEQUENCE conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.conversations_id_seq;
       public       nolan    false    3    209                       0    0    conversations_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE conversations_id_seq OWNED BY conversations.id;
            public       nolan    false    210            �            1259    195927    custom_emojis    TABLE     L  CREATE TABLE custom_emojis (
    id bigint NOT NULL,
    shortcode character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    uri character varying,
    image_remote_url character varying,
    visible_in_picker boolean DEFAULT true NOT NULL
);
 !   DROP TABLE public.custom_emojis;
       public         nolan    false    3            �            1259    195936    custom_emojis_id_seq    SEQUENCE     v   CREATE SEQUENCE custom_emojis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.custom_emojis_id_seq;
       public       nolan    false    3    211            	           0    0    custom_emojis_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE custom_emojis_id_seq OWNED BY custom_emojis.id;
            public       nolan    false    212            �            1259    195938    domain_blocks    TABLE     7  CREATE TABLE domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    severity integer DEFAULT 0,
    reject_media boolean DEFAULT false NOT NULL
);
 !   DROP TABLE public.domain_blocks;
       public         nolan    false    3            �            1259    195947    domain_blocks_id_seq    SEQUENCE     v   CREATE SEQUENCE domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.domain_blocks_id_seq;
       public       nolan    false    213    3            
           0    0    domain_blocks_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE domain_blocks_id_seq OWNED BY domain_blocks.id;
            public       nolan    false    214            �            1259    195949    email_domain_blocks    TABLE     �   CREATE TABLE email_domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 '   DROP TABLE public.email_domain_blocks;
       public         nolan    false    3            �            1259    195956    email_domain_blocks_id_seq    SEQUENCE     |   CREATE SEQUENCE email_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.email_domain_blocks_id_seq;
       public       nolan    false    215    3                       0    0    email_domain_blocks_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE email_domain_blocks_id_seq OWNED BY email_domain_blocks.id;
            public       nolan    false    216            �            1259    195958 
   favourites    TABLE     �   CREATE TABLE favourites (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL
);
    DROP TABLE public.favourites;
       public         nolan    false    3            �            1259    195961    favourites_id_seq    SEQUENCE     s   CREATE SEQUENCE favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.favourites_id_seq;
       public       nolan    false    3    217                       0    0    favourites_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE favourites_id_seq OWNED BY favourites.id;
            public       nolan    false    218            �            1259    195963    follow_requests    TABLE       CREATE TABLE follow_requests (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
 #   DROP TABLE public.follow_requests;
       public         nolan    false    3            �            1259    195967    follow_requests_id_seq    SEQUENCE     x   CREATE SEQUENCE follow_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.follow_requests_id_seq;
       public       nolan    false    219    3                       0    0    follow_requests_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE follow_requests_id_seq OWNED BY follow_requests.id;
            public       nolan    false    220            �            1259    195969    follows    TABLE       CREATE TABLE follows (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
    DROP TABLE public.follows;
       public         nolan    false    3            �            1259    195973    follows_id_seq    SEQUENCE     p   CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.follows_id_seq;
       public       nolan    false    3    221                       0    0    follows_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE follows_id_seq OWNED BY follows.id;
            public       nolan    false    222            �            1259    195975    imports    TABLE     �  CREATE TABLE imports (
    id bigint NOT NULL,
    type integer NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data_file_name character varying,
    data_content_type character varying,
    data_file_size integer,
    data_updated_at timestamp without time zone,
    account_id bigint NOT NULL
);
    DROP TABLE public.imports;
       public         nolan    false    3            �            1259    195982    imports_id_seq    SEQUENCE     p   CREATE SEQUENCE imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.imports_id_seq;
       public       nolan    false    3    223                       0    0    imports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE imports_id_seq OWNED BY imports.id;
            public       nolan    false    224            �            1259    195984    invites    TABLE     Y  CREATE TABLE invites (
    id bigint NOT NULL,
    user_id bigint,
    code character varying DEFAULT ''::character varying NOT NULL,
    expires_at timestamp without time zone,
    max_uses integer,
    uses integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.invites;
       public         nolan    false    3            �            1259    195992    invites_id_seq    SEQUENCE     p   CREATE SEQUENCE invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.invites_id_seq;
       public       nolan    false    225    3                       0    0    invites_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE invites_id_seq OWNED BY invites.id;
            public       nolan    false    226            �            1259    195994    list_accounts    TABLE     �   CREATE TABLE list_accounts (
    id bigint NOT NULL,
    list_id bigint NOT NULL,
    account_id bigint NOT NULL,
    follow_id bigint NOT NULL
);
 !   DROP TABLE public.list_accounts;
       public         nolan    false    3            �            1259    195997    list_accounts_id_seq    SEQUENCE     v   CREATE SEQUENCE list_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.list_accounts_id_seq;
       public       nolan    false    3    227                       0    0    list_accounts_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE list_accounts_id_seq OWNED BY list_accounts.id;
            public       nolan    false    228            �            1259    195999    lists    TABLE     �   CREATE TABLE lists (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.lists;
       public         nolan    false    3            �            1259    196006    lists_id_seq    SEQUENCE     n   CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.lists_id_seq;
       public       nolan    false    3    229                       0    0    lists_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE lists_id_seq OWNED BY lists.id;
            public       nolan    false    230            �            1259    196008    media_attachments    TABLE     '  CREATE TABLE media_attachments (
    id bigint NOT NULL,
    status_id bigint,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    shortcode character varying,
    type integer DEFAULT 0 NOT NULL,
    file_meta json,
    account_id bigint,
    description text
);
 %   DROP TABLE public.media_attachments;
       public         nolan    false    3            �            1259    196016    media_attachments_id_seq    SEQUENCE     z   CREATE SEQUENCE media_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.media_attachments_id_seq;
       public       nolan    false    3    231                       0    0    media_attachments_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE media_attachments_id_seq OWNED BY media_attachments.id;
            public       nolan    false    232            �            1259    196018    mentions    TABLE     �   CREATE TABLE mentions (
    id bigint NOT NULL,
    status_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
    DROP TABLE public.mentions;
       public         nolan    false    3            �            1259    196021    mentions_id_seq    SEQUENCE     q   CREATE SEQUENCE mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.mentions_id_seq;
       public       nolan    false    3    233                       0    0    mentions_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE mentions_id_seq OWNED BY mentions.id;
            public       nolan    false    234            �            1259    196023    mutes    TABLE       CREATE TABLE mutes (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    hide_notifications boolean DEFAULT true NOT NULL
);
    DROP TABLE public.mutes;
       public         nolan    false    3            �            1259    196027    mutes_id_seq    SEQUENCE     n   CREATE SEQUENCE mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.mutes_id_seq;
       public       nolan    false    3    235                       0    0    mutes_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE mutes_id_seq OWNED BY mutes.id;
            public       nolan    false    236            �            1259    196029    notifications    TABLE       CREATE TABLE notifications (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint,
    from_account_id bigint
);
 !   DROP TABLE public.notifications;
       public         nolan    false    3            �            1259    196035    notifications_id_seq    SEQUENCE     v   CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.notifications_id_seq;
       public       nolan    false    3    237                       0    0    notifications_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;
            public       nolan    false    238            �            1259    196037    oauth_access_grants    TABLE     n  CREATE TABLE oauth_access_grants (
    id bigint NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying,
    application_id bigint NOT NULL,
    resource_owner_id bigint NOT NULL
);
 '   DROP TABLE public.oauth_access_grants;
       public         nolan    false    3            �            1259    196043    oauth_access_grants_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_grants_id_seq;
       public       nolan    false    3    239                       0    0    oauth_access_grants_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;
            public       nolan    false    240            �            1259    196045    oauth_access_tokens    TABLE     X  CREATE TABLE oauth_access_tokens (
    id bigint NOT NULL,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying,
    application_id bigint,
    resource_owner_id bigint
);
 '   DROP TABLE public.oauth_access_tokens;
       public         nolan    false    3            �            1259    196051    oauth_access_tokens_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_tokens_id_seq;
       public       nolan    false    3    241                       0    0    oauth_access_tokens_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;
            public       nolan    false    242            �            1259    196053    oauth_applications    TABLE     �  CREATE TABLE oauth_applications (
    id bigint NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    superapp boolean DEFAULT false NOT NULL,
    website character varying,
    owner_type character varying,
    owner_id bigint
);
 &   DROP TABLE public.oauth_applications;
       public         nolan    false    3            �            1259    196061    oauth_applications_id_seq    SEQUENCE     {   CREATE SEQUENCE oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.oauth_applications_id_seq;
       public       nolan    false    3    243                       0    0    oauth_applications_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;
            public       nolan    false    244            �            1259    196063    preview_cards    TABLE       CREATE TABLE preview_cards (
    id bigint NOT NULL,
    url character varying DEFAULT ''::character varying NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    type integer DEFAULT 0 NOT NULL,
    html text DEFAULT ''::text NOT NULL,
    author_name character varying DEFAULT ''::character varying NOT NULL,
    author_url character varying DEFAULT ''::character varying NOT NULL,
    provider_name character varying DEFAULT ''::character varying NOT NULL,
    provider_url character varying DEFAULT ''::character varying NOT NULL,
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    embed_url character varying DEFAULT ''::character varying NOT NULL
);
 !   DROP TABLE public.preview_cards;
       public         nolan    false    3            �            1259    196081    preview_cards_id_seq    SEQUENCE     v   CREATE SEQUENCE preview_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.preview_cards_id_seq;
       public       nolan    false    3    245                       0    0    preview_cards_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE preview_cards_id_seq OWNED BY preview_cards.id;
            public       nolan    false    246            �            1259    196083    preview_cards_statuses    TABLE     l   CREATE TABLE preview_cards_statuses (
    preview_card_id bigint NOT NULL,
    status_id bigint NOT NULL
);
 *   DROP TABLE public.preview_cards_statuses;
       public         nolan    false    3            �            1259    196086    reports    TABLE     �  CREATE TABLE reports (
    id bigint NOT NULL,
    status_ids bigint[] DEFAULT '{}'::bigint[] NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    action_taken boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    action_taken_by_account_id bigint,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.reports;
       public         nolan    false    3            �            1259    196095    reports_id_seq    SEQUENCE     p   CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reports_id_seq;
       public       nolan    false    3    248                       0    0    reports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE reports_id_seq OWNED BY reports.id;
            public       nolan    false    249            �            1259    196097    schema_migrations    TABLE     K   CREATE TABLE schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         nolan    false    3            �            1259    196103    session_activations    TABLE     �  CREATE TABLE session_activations (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_agent character varying DEFAULT ''::character varying NOT NULL,
    ip inet,
    access_token_id bigint,
    user_id bigint NOT NULL,
    web_push_subscription_id bigint
);
 '   DROP TABLE public.session_activations;
       public         nolan    false    3            �            1259    196110    session_activations_id_seq    SEQUENCE     |   CREATE SEQUENCE session_activations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.session_activations_id_seq;
       public       nolan    false    251    3                       0    0    session_activations_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE session_activations_id_seq OWNED BY session_activations.id;
            public       nolan    false    252            �            1259    196112    settings    TABLE     �   CREATE TABLE settings (
    id bigint NOT NULL,
    var character varying NOT NULL,
    value text,
    thing_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    thing_id bigint
);
    DROP TABLE public.settings;
       public         nolan    false    3            �            1259    196118    settings_id_seq    SEQUENCE     q   CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.settings_id_seq;
       public       nolan    false    3    253                       0    0    settings_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE settings_id_seq OWNED BY settings.id;
            public       nolan    false    254            �            1259    196120    site_uploads    TABLE     �  CREATE TABLE site_uploads (
    id bigint NOT NULL,
    var character varying DEFAULT ''::character varying NOT NULL,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    meta json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
     DROP TABLE public.site_uploads;
       public         nolan    false    3                        1259    196127    site_uploads_id_seq    SEQUENCE     u   CREATE SEQUENCE site_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.site_uploads_id_seq;
       public       nolan    false    3    255                       0    0    site_uploads_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE site_uploads_id_seq OWNED BY site_uploads.id;
            public       nolan    false    256                       1259    196129    status_pins    TABLE     �   CREATE TABLE status_pins (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.status_pins;
       public         nolan    false    3                       1259    196134    status_pins_id_seq    SEQUENCE     t   CREATE SEQUENCE status_pins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.status_pins_id_seq;
       public       nolan    false    3    257                       0    0    status_pins_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE status_pins_id_seq OWNED BY status_pins.id;
            public       nolan    false    258                       1259    196136    statuses    TABLE       CREATE TABLE statuses (
    id bigint DEFAULT timestamp_id('statuses'::text) NOT NULL,
    uri character varying,
    text text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    in_reply_to_id bigint,
    reblog_of_id bigint,
    url character varying,
    sensitive boolean DEFAULT false NOT NULL,
    visibility integer DEFAULT 0 NOT NULL,
    spoiler_text text DEFAULT ''::text NOT NULL,
    reply boolean DEFAULT false NOT NULL,
    favourites_count integer DEFAULT 0 NOT NULL,
    reblogs_count integer DEFAULT 0 NOT NULL,
    language character varying,
    conversation_id bigint,
    local boolean,
    account_id bigint NOT NULL,
    application_id bigint,
    in_reply_to_account_id bigint
);
    DROP TABLE public.statuses;
       public         nolan    false    277    3                       1259    196150    statuses_id_seq    SEQUENCE     q   CREATE SEQUENCE statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.statuses_id_seq;
       public       nolan    false    3                       1259    196152    statuses_tags    TABLE     Z   CREATE TABLE statuses_tags (
    status_id bigint NOT NULL,
    tag_id bigint NOT NULL
);
 !   DROP TABLE public.statuses_tags;
       public         nolan    false    3                       1259    196155    stream_entries    TABLE     !  CREATE TABLE stream_entries (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    account_id bigint
);
 "   DROP TABLE public.stream_entries;
       public         nolan    false    3                       1259    196162    stream_entries_id_seq    SEQUENCE     w   CREATE SEQUENCE stream_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.stream_entries_id_seq;
       public       nolan    false    3    262                        0    0    stream_entries_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE stream_entries_id_seq OWNED BY stream_entries.id;
            public       nolan    false    263                       1259    196164    subscriptions    TABLE     �  CREATE TABLE subscriptions (
    id bigint NOT NULL,
    callback_url character varying DEFAULT ''::character varying NOT NULL,
    secret character varying,
    expires_at timestamp without time zone,
    confirmed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_successful_delivery_at timestamp without time zone,
    domain character varying,
    account_id bigint NOT NULL
);
 !   DROP TABLE public.subscriptions;
       public         nolan    false    3            	           1259    196172    subscriptions_id_seq    SEQUENCE     v   CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.subscriptions_id_seq;
       public       nolan    false    3    264            !           0    0    subscriptions_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;
            public       nolan    false    265            
           1259    196174    tags    TABLE     �   CREATE TABLE tags (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.tags;
       public         nolan    false    3                       1259    196181    tags_id_seq    SEQUENCE     m   CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.tags_id_seq;
       public       nolan    false    3    266            "           0    0    tags_id_seq    SEQUENCE OWNED BY     -   ALTER SEQUENCE tags_id_seq OWNED BY tags.id;
            public       nolan    false    267                       1259    196183    users    TABLE     �  CREATE TABLE users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    admin boolean DEFAULT false NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    locale character varying,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying,
    encrypted_otp_secret_salt character varying,
    consumed_timestep integer,
    otp_required_for_login boolean DEFAULT false NOT NULL,
    last_emailed_at timestamp without time zone,
    otp_backup_codes character varying[],
    filtered_languages character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    account_id bigint NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    moderator boolean DEFAULT false NOT NULL,
    invite_id bigint
);
    DROP TABLE public.users;
       public         nolan    false    3                       1259    196197    users_id_seq    SEQUENCE     n   CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       nolan    false    3    268            #           0    0    users_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE users_id_seq OWNED BY users.id;
            public       nolan    false    269                       1259    196199    web_push_subscriptions    TABLE     6  CREATE TABLE web_push_subscriptions (
    id bigint NOT NULL,
    endpoint character varying NOT NULL,
    key_p256dh character varying NOT NULL,
    key_auth character varying NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 *   DROP TABLE public.web_push_subscriptions;
       public         nolan    false    3                       1259    196205    web_push_subscriptions_id_seq    SEQUENCE        CREATE SEQUENCE web_push_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.web_push_subscriptions_id_seq;
       public       nolan    false    3    270            $           0    0    web_push_subscriptions_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE web_push_subscriptions_id_seq OWNED BY web_push_subscriptions.id;
            public       nolan    false    271                       1259    196207    web_settings    TABLE     �   CREATE TABLE web_settings (
    id bigint NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint
);
     DROP TABLE public.web_settings;
       public         nolan    false    3                       1259    196213    web_settings_id_seq    SEQUENCE     u   CREATE SEQUENCE web_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.web_settings_id_seq;
       public       nolan    false    272    3            %           0    0    web_settings_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE web_settings_id_seq OWNED BY web_settings.id;
            public       nolan    false    273            �	           2604    196215    account_domain_blocks id    DEFAULT     v   ALTER TABLE ONLY account_domain_blocks ALTER COLUMN id SET DEFAULT nextval('account_domain_blocks_id_seq'::regclass);
 G   ALTER TABLE public.account_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    197    196            �	           2604    196216    account_moderation_notes id    DEFAULT     |   ALTER TABLE ONLY account_moderation_notes ALTER COLUMN id SET DEFAULT nextval('account_moderation_notes_id_seq'::regclass);
 J   ALTER TABLE public.account_moderation_notes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    199    198            
           2604    196217    accounts id    DEFAULT     \   ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);
 :   ALTER TABLE public.accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    201    200            
           2604    196218    admin_action_logs id    DEFAULT     n   ALTER TABLE ONLY admin_action_logs ALTER COLUMN id SET DEFAULT nextval('admin_action_logs_id_seq'::regclass);
 C   ALTER TABLE public.admin_action_logs ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    203    202            
           2604    196219 	   blocks id    DEFAULT     X   ALTER TABLE ONLY blocks ALTER COLUMN id SET DEFAULT nextval('blocks_id_seq'::regclass);
 8   ALTER TABLE public.blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    206    205            
           2604    196220    conversation_mutes id    DEFAULT     p   ALTER TABLE ONLY conversation_mutes ALTER COLUMN id SET DEFAULT nextval('conversation_mutes_id_seq'::regclass);
 D   ALTER TABLE public.conversation_mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    208    207            
           2604    196221    conversations id    DEFAULT     f   ALTER TABLE ONLY conversations ALTER COLUMN id SET DEFAULT nextval('conversations_id_seq'::regclass);
 ?   ALTER TABLE public.conversations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    210    209            
           2604    196222    custom_emojis id    DEFAULT     f   ALTER TABLE ONLY custom_emojis ALTER COLUMN id SET DEFAULT nextval('custom_emojis_id_seq'::regclass);
 ?   ALTER TABLE public.custom_emojis ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    212    211            
           2604    196223    domain_blocks id    DEFAULT     f   ALTER TABLE ONLY domain_blocks ALTER COLUMN id SET DEFAULT nextval('domain_blocks_id_seq'::regclass);
 ?   ALTER TABLE public.domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    214    213             
           2604    196224    email_domain_blocks id    DEFAULT     r   ALTER TABLE ONLY email_domain_blocks ALTER COLUMN id SET DEFAULT nextval('email_domain_blocks_id_seq'::regclass);
 E   ALTER TABLE public.email_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    216    215            !
           2604    196225    favourites id    DEFAULT     `   ALTER TABLE ONLY favourites ALTER COLUMN id SET DEFAULT nextval('favourites_id_seq'::regclass);
 <   ALTER TABLE public.favourites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    218    217            #
           2604    196226    follow_requests id    DEFAULT     j   ALTER TABLE ONLY follow_requests ALTER COLUMN id SET DEFAULT nextval('follow_requests_id_seq'::regclass);
 A   ALTER TABLE public.follow_requests ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    220    219            %
           2604    196227 
   follows id    DEFAULT     Z   ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);
 9   ALTER TABLE public.follows ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    222    221            '
           2604    196228 
   imports id    DEFAULT     Z   ALTER TABLE ONLY imports ALTER COLUMN id SET DEFAULT nextval('imports_id_seq'::regclass);
 9   ALTER TABLE public.imports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    224    223            *
           2604    196229 
   invites id    DEFAULT     Z   ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);
 9   ALTER TABLE public.invites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    226    225            +
           2604    196230    list_accounts id    DEFAULT     f   ALTER TABLE ONLY list_accounts ALTER COLUMN id SET DEFAULT nextval('list_accounts_id_seq'::regclass);
 ?   ALTER TABLE public.list_accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    228    227            -
           2604    196231    lists id    DEFAULT     V   ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);
 7   ALTER TABLE public.lists ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    230    229            0
           2604    196232    media_attachments id    DEFAULT     n   ALTER TABLE ONLY media_attachments ALTER COLUMN id SET DEFAULT nextval('media_attachments_id_seq'::regclass);
 C   ALTER TABLE public.media_attachments ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    232    231            1
           2604    196233    mentions id    DEFAULT     \   ALTER TABLE ONLY mentions ALTER COLUMN id SET DEFAULT nextval('mentions_id_seq'::regclass);
 :   ALTER TABLE public.mentions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    234    233            3
           2604    196234    mutes id    DEFAULT     V   ALTER TABLE ONLY mutes ALTER COLUMN id SET DEFAULT nextval('mutes_id_seq'::regclass);
 7   ALTER TABLE public.mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    236    235            4
           2604    196235    notifications id    DEFAULT     f   ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);
 ?   ALTER TABLE public.notifications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    238    237            5
           2604    196236    oauth_access_grants id    DEFAULT     r   ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_grants ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    240    239            6
           2604    196237    oauth_access_tokens id    DEFAULT     r   ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_tokens ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    242    241            9
           2604    196238    oauth_applications id    DEFAULT     p   ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);
 D   ALTER TABLE public.oauth_applications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    244    243            F
           2604    196239    preview_cards id    DEFAULT     f   ALTER TABLE ONLY preview_cards ALTER COLUMN id SET DEFAULT nextval('preview_cards_id_seq'::regclass);
 ?   ALTER TABLE public.preview_cards ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    246    245            J
           2604    196240 
   reports id    DEFAULT     Z   ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);
 9   ALTER TABLE public.reports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    249    248            L
           2604    196241    session_activations id    DEFAULT     r   ALTER TABLE ONLY session_activations ALTER COLUMN id SET DEFAULT nextval('session_activations_id_seq'::regclass);
 E   ALTER TABLE public.session_activations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    252    251            M
           2604    196242    settings id    DEFAULT     \   ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);
 :   ALTER TABLE public.settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    254    253            O
           2604    196243    site_uploads id    DEFAULT     d   ALTER TABLE ONLY site_uploads ALTER COLUMN id SET DEFAULT nextval('site_uploads_id_seq'::regclass);
 >   ALTER TABLE public.site_uploads ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    256    255            R
           2604    196244    status_pins id    DEFAULT     b   ALTER TABLE ONLY status_pins ALTER COLUMN id SET DEFAULT nextval('status_pins_id_seq'::regclass);
 =   ALTER TABLE public.status_pins ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    258    257            \
           2604    196245    stream_entries id    DEFAULT     h   ALTER TABLE ONLY stream_entries ALTER COLUMN id SET DEFAULT nextval('stream_entries_id_seq'::regclass);
 @   ALTER TABLE public.stream_entries ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    263    262            _
           2604    196246    subscriptions id    DEFAULT     f   ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);
 ?   ALTER TABLE public.subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    265    264            a
           2604    196247    tags id    DEFAULT     T   ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);
 6   ALTER TABLE public.tags ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    267    266            j
           2604    196248    users id    DEFAULT     V   ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    269    268            k
           2604    196249    web_push_subscriptions id    DEFAULT     x   ALTER TABLE ONLY web_push_subscriptions ALTER COLUMN id SET DEFAULT nextval('web_push_subscriptions_id_seq'::regclass);
 H   ALTER TABLE public.web_push_subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    271    270            l
           2604    196250    web_settings id    DEFAULT     d   ALTER TABLE ONLY web_settings ALTER COLUMN id SET DEFAULT nextval('web_settings_id_seq'::regclass);
 >   ALTER TABLE public.web_settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    273    272            �          0    195847    account_domain_blocks 
   TABLE DATA               X   COPY account_domain_blocks (id, domain, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    196   �      �          0    195855    account_moderation_notes 
   TABLE DATA               o   COPY account_moderation_notes (id, content, account_id, target_account_id, created_at, updated_at) FROM stdin;
    public       nolan    false    198   ;�      �          0    195863    accounts 
   TABLE DATA               E  COPY accounts (id, username, domain, secret, private_key, public_key, remote_url, salmon_url, hub_url, created_at, updated_at, note, display_name, uri, url, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at, header_file_name, header_content_type, header_file_size, header_updated_at, avatar_remote_url, subscription_expires_at, silenced, suspended, locked, header_remote_url, statuses_count, followers_count, following_count, last_webfingered_at, inbox_url, outbox_url, shared_inbox_url, followers_url, protocol, memorial, moved_to_account_id) FROM stdin;
    public       nolan    false    200   X�      �          0    195893    admin_action_logs 
   TABLE DATA               ~   COPY admin_action_logs (id, account_id, action, target_type, target_id, recorded_changes, created_at, updated_at) FROM stdin;
    public       nolan    false    202   �      �          0    195903    ar_internal_metadata 
   TABLE DATA               K   COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public       nolan    false    204   �      �          0    195909    blocks 
   TABLE DATA               T   COPY blocks (id, created_at, updated_at, account_id, target_account_id) FROM stdin;
    public       nolan    false    205   �      �          0    195914    conversation_mutes 
   TABLE DATA               F   COPY conversation_mutes (id, conversation_id, account_id) FROM stdin;
    public       nolan    false    207          �          0    195919    conversations 
   TABLE DATA               A   COPY conversations (id, uri, created_at, updated_at) FROM stdin;
    public       nolan    false    209         �          0    195927    custom_emojis 
   TABLE DATA               �   COPY custom_emojis (id, shortcode, domain, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at, disabled, uri, image_remote_url, visible_in_picker) FROM stdin;
    public       nolan    false    211   :      �          0    195938    domain_blocks 
   TABLE DATA               \   COPY domain_blocks (id, domain, created_at, updated_at, severity, reject_media) FROM stdin;
    public       nolan    false    213   �      �          0    195949    email_domain_blocks 
   TABLE DATA               J   COPY email_domain_blocks (id, domain, created_at, updated_at) FROM stdin;
    public       nolan    false    215         �          0    195958 
   favourites 
   TABLE DATA               P   COPY favourites (id, created_at, updated_at, account_id, status_id) FROM stdin;
    public       nolan    false    217   #      �          0    195963    follow_requests 
   TABLE DATA               k   COPY follow_requests (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    219   @      �          0    195969    follows 
   TABLE DATA               c   COPY follows (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    221   ]      �          0    195975    imports 
   TABLE DATA               �   COPY imports (id, type, approved, created_at, updated_at, data_file_name, data_content_type, data_file_size, data_updated_at, account_id) FROM stdin;
    public       nolan    false    223   �      �          0    195984    invites 
   TABLE DATA               a   COPY invites (id, user_id, code, expires_at, max_uses, uses, created_at, updated_at) FROM stdin;
    public       nolan    false    225   �      �          0    195994    list_accounts 
   TABLE DATA               D   COPY list_accounts (id, list_id, account_id, follow_id) FROM stdin;
    public       nolan    false    227   �      �          0    195999    lists 
   TABLE DATA               G   COPY lists (id, account_id, title, created_at, updated_at) FROM stdin;
    public       nolan    false    229         �          0    196008    media_attachments 
   TABLE DATA               �   COPY media_attachments (id, status_id, file_file_name, file_content_type, file_file_size, file_updated_at, remote_url, created_at, updated_at, shortcode, type, file_meta, account_id, description) FROM stdin;
    public       nolan    false    231   -      �          0    196018    mentions 
   TABLE DATA               N   COPY mentions (id, status_id, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    233   J      �          0    196023    mutes 
   TABLE DATA               g   COPY mutes (id, created_at, updated_at, account_id, target_account_id, hide_notifications) FROM stdin;
    public       nolan    false    235   g      �          0    196029    notifications 
   TABLE DATA               u   COPY notifications (id, activity_id, activity_type, created_at, updated_at, account_id, from_account_id) FROM stdin;
    public       nolan    false    237   �      �          0    196037    oauth_access_grants 
   TABLE DATA               �   COPY oauth_access_grants (id, token, expires_in, redirect_uri, created_at, revoked_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    239   �      �          0    196045    oauth_access_tokens 
   TABLE DATA               �   COPY oauth_access_tokens (id, token, refresh_token, expires_in, revoked_at, created_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    241   	      �          0    196053    oauth_applications 
   TABLE DATA               �   COPY oauth_applications (id, name, uid, secret, redirect_uri, scopes, created_at, updated_at, superapp, website, owner_type, owner_id) FROM stdin;
    public       nolan    false    243   #      �          0    196063    preview_cards 
   TABLE DATA               �   COPY preview_cards (id, url, title, description, image_file_name, image_content_type, image_file_size, image_updated_at, type, html, author_name, author_url, provider_name, provider_url, width, height, created_at, updated_at, embed_url) FROM stdin;
    public       nolan    false    245   �      �          0    196083    preview_cards_statuses 
   TABLE DATA               E   COPY preview_cards_statuses (preview_card_id, status_id) FROM stdin;
    public       nolan    false    247         �          0    196086    reports 
   TABLE DATA               �   COPY reports (id, status_ids, comment, action_taken, created_at, updated_at, account_id, action_taken_by_account_id, target_account_id) FROM stdin;
    public       nolan    false    248   !      �          0    196097    schema_migrations 
   TABLE DATA               -   COPY schema_migrations (version) FROM stdin;
    public       nolan    false    250   >      �          0    196103    session_activations 
   TABLE DATA               �   COPY session_activations (id, session_id, created_at, updated_at, user_agent, ip, access_token_id, user_id, web_push_subscription_id) FROM stdin;
    public       nolan    false    251   L      �          0    196112    settings 
   TABLE DATA               Y   COPY settings (id, var, value, thing_type, created_at, updated_at, thing_id) FROM stdin;
    public       nolan    false    253   �      �          0    196120    site_uploads 
   TABLE DATA               �   COPY site_uploads (id, var, file_file_name, file_content_type, file_file_size, file_updated_at, meta, created_at, updated_at) FROM stdin;
    public       nolan    false    255   �      �          0    196129    status_pins 
   TABLE DATA               Q   COPY status_pins (id, account_id, status_id, created_at, updated_at) FROM stdin;
    public       nolan    false    257   �      �          0    196136    statuses 
   TABLE DATA                 COPY statuses (id, uri, text, created_at, updated_at, in_reply_to_id, reblog_of_id, url, sensitive, visibility, spoiler_text, reply, favourites_count, reblogs_count, language, conversation_id, local, account_id, application_id, in_reply_to_account_id) FROM stdin;
    public       nolan    false    259         �          0    196152    statuses_tags 
   TABLE DATA               3   COPY statuses_tags (status_id, tag_id) FROM stdin;
    public       nolan    false    261   #      �          0    196155    stream_entries 
   TABLE DATA               m   COPY stream_entries (id, activity_id, activity_type, created_at, updated_at, hidden, account_id) FROM stdin;
    public       nolan    false    262   @      �          0    196164    subscriptions 
   TABLE DATA               �   COPY subscriptions (id, callback_url, secret, expires_at, confirmed, created_at, updated_at, last_successful_delivery_at, domain, account_id) FROM stdin;
    public       nolan    false    264   ]      �          0    196174    tags 
   TABLE DATA               9   COPY tags (id, name, created_at, updated_at) FROM stdin;
    public       nolan    false    266   z      �          0    196183    users 
   TABLE DATA                 COPY users (id, email, created_at, updated_at, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, admin, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, locale, encrypted_otp_secret, encrypted_otp_secret_iv, encrypted_otp_secret_salt, consumed_timestep, otp_required_for_login, last_emailed_at, otp_backup_codes, filtered_languages, account_id, disabled, moderator, invite_id) FROM stdin;
    public       nolan    false    268   �      �          0    196199    web_push_subscriptions 
   TABLE DATA               k   COPY web_push_subscriptions (id, endpoint, key_p256dh, key_auth, data, created_at, updated_at) FROM stdin;
    public       nolan    false    270   �      �          0    196207    web_settings 
   TABLE DATA               J   COPY web_settings (id, data, created_at, updated_at, user_id) FROM stdin;
    public       nolan    false    272   
      &           0    0    account_domain_blocks_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('account_domain_blocks_id_seq', 1, false);
            public       nolan    false    197            '           0    0    account_moderation_notes_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('account_moderation_notes_id_seq', 1, false);
            public       nolan    false    199            (           0    0    accounts_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('accounts_id_seq', 4, true);
            public       nolan    false    201            )           0    0    admin_action_logs_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('admin_action_logs_id_seq', 3, true);
            public       nolan    false    203            *           0    0    blocks_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('blocks_id_seq', 1, false);
            public       nolan    false    206            +           0    0    conversation_mutes_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('conversation_mutes_id_seq', 1, false);
            public       nolan    false    208            ,           0    0    conversations_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('conversations_id_seq', 1, false);
            public       nolan    false    210            -           0    0    custom_emojis_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('custom_emojis_id_seq', 3, true);
            public       nolan    false    212            .           0    0    domain_blocks_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('domain_blocks_id_seq', 1, false);
            public       nolan    false    214            /           0    0    email_domain_blocks_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('email_domain_blocks_id_seq', 1, false);
            public       nolan    false    216            0           0    0    favourites_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('favourites_id_seq', 1, false);
            public       nolan    false    218            1           0    0    follow_requests_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('follow_requests_id_seq', 1, false);
            public       nolan    false    220            2           0    0    follows_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('follows_id_seq', 3, true);
            public       nolan    false    222            3           0    0    imports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('imports_id_seq', 1, false);
            public       nolan    false    224            4           0    0    invites_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('invites_id_seq', 1, false);
            public       nolan    false    226            5           0    0    list_accounts_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('list_accounts_id_seq', 1, false);
            public       nolan    false    228            6           0    0    lists_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('lists_id_seq', 1, false);
            public       nolan    false    230            7           0    0    media_attachments_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('media_attachments_id_seq', 1, false);
            public       nolan    false    232            8           0    0    mentions_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('mentions_id_seq', 1, false);
            public       nolan    false    234            9           0    0    mutes_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('mutes_id_seq', 1, false);
            public       nolan    false    236            :           0    0    notifications_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('notifications_id_seq', 3, true);
            public       nolan    false    238            ;           0    0    oauth_access_grants_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('oauth_access_grants_id_seq', 1, false);
            public       nolan    false    240            <           0    0    oauth_access_tokens_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('oauth_access_tokens_id_seq', 5, true);
            public       nolan    false    242            =           0    0    oauth_applications_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('oauth_applications_id_seq', 1, true);
            public       nolan    false    244            >           0    0    preview_cards_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('preview_cards_id_seq', 1, false);
            public       nolan    false    246            ?           0    0    reports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('reports_id_seq', 1, false);
            public       nolan    false    249            @           0    0    session_activations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('session_activations_id_seq', 5, true);
            public       nolan    false    252            A           0    0    settings_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('settings_id_seq', 1, false);
            public       nolan    false    254            B           0    0    site_uploads_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('site_uploads_id_seq', 1, false);
            public       nolan    false    256            C           0    0    status_pins_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('status_pins_id_seq', 1, false);
            public       nolan    false    258            D           0    0    statuses_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('statuses_id_seq', 1, false);
            public       nolan    false    260            E           0    0    stream_entries_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('stream_entries_id_seq', 1, false);
            public       nolan    false    263            F           0    0    subscriptions_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('subscriptions_id_seq', 1, false);
            public       nolan    false    265            G           0    0    tags_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('tags_id_seq', 1, false);
            public       nolan    false    267            H           0    0    users_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('users_id_seq', 4, true);
            public       nolan    false    269            I           0    0    web_push_subscriptions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('web_push_subscriptions_id_seq', 1, false);
            public       nolan    false    271            J           0    0    web_settings_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('web_settings_id_seq', 2, true);
            public       nolan    false    273            n
           2606    196256 0   account_domain_blocks account_domain_blocks_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT account_domain_blocks_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT account_domain_blocks_pkey;
       public         nolan    false    196            q
           2606    196258 6   account_moderation_notes account_moderation_notes_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT account_moderation_notes_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT account_moderation_notes_pkey;
       public         nolan    false    198            u
           2606    196260    accounts accounts_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
       public         nolan    false    200            |
           2606    196262 (   admin_action_logs admin_action_logs_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT admin_action_logs_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT admin_action_logs_pkey;
       public         nolan    false    202            �
           2606    196264 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public         nolan    false    204            �
           2606    196266    blocks blocks_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.blocks DROP CONSTRAINT blocks_pkey;
       public         nolan    false    205            �
           2606    196268 *   conversation_mutes conversation_mutes_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT conversation_mutes_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT conversation_mutes_pkey;
       public         nolan    false    207            �
           2606    196270     conversations conversations_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_pkey;
       public         nolan    false    209            �
           2606    196272     custom_emojis custom_emojis_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY custom_emojis
    ADD CONSTRAINT custom_emojis_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.custom_emojis DROP CONSTRAINT custom_emojis_pkey;
       public         nolan    false    211            �
           2606    196274     domain_blocks domain_blocks_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY domain_blocks
    ADD CONSTRAINT domain_blocks_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.domain_blocks DROP CONSTRAINT domain_blocks_pkey;
       public         nolan    false    213            �
           2606    196276 ,   email_domain_blocks email_domain_blocks_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY email_domain_blocks
    ADD CONSTRAINT email_domain_blocks_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.email_domain_blocks DROP CONSTRAINT email_domain_blocks_pkey;
       public         nolan    false    215            �
           2606    196278    favourites favourites_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.favourites DROP CONSTRAINT favourites_pkey;
       public         nolan    false    217            �
           2606    196280 $   follow_requests follow_requests_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT follow_requests_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT follow_requests_pkey;
       public         nolan    false    219            �
           2606    196282    follows follows_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.follows DROP CONSTRAINT follows_pkey;
       public         nolan    false    221            �
           2606    196284    imports imports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.imports DROP CONSTRAINT imports_pkey;
       public         nolan    false    223            �
           2606    196286    invites invites_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.invites DROP CONSTRAINT invites_pkey;
       public         nolan    false    225            �
           2606    196288     list_accounts list_accounts_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT list_accounts_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT list_accounts_pkey;
       public         nolan    false    227            �
           2606    196290    lists lists_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.lists DROP CONSTRAINT lists_pkey;
       public         nolan    false    229            �
           2606    196292 (   media_attachments media_attachments_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT media_attachments_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT media_attachments_pkey;
       public         nolan    false    231            �
           2606    196294    mentions mentions_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT mentions_pkey;
       public         nolan    false    233            �
           2606    196296    mutes mutes_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY mutes
    ADD CONSTRAINT mutes_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.mutes DROP CONSTRAINT mutes_pkey;
       public         nolan    false    235            �
           2606    196298     notifications notifications_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.notifications DROP CONSTRAINT notifications_pkey;
       public         nolan    false    237            �
           2606    196300 ,   oauth_access_grants oauth_access_grants_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT oauth_access_grants_pkey;
       public         nolan    false    239            �
           2606    196302 ,   oauth_access_tokens oauth_access_tokens_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT oauth_access_tokens_pkey;
       public         nolan    false    241            �
           2606    196304 *   oauth_applications oauth_applications_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT oauth_applications_pkey;
       public         nolan    false    243            �
           2606    196306     preview_cards preview_cards_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY preview_cards
    ADD CONSTRAINT preview_cards_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.preview_cards DROP CONSTRAINT preview_cards_pkey;
       public         nolan    false    245            �
           2606    196308    reports reports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.reports DROP CONSTRAINT reports_pkey;
       public         nolan    false    248            �
           2606    196310 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public         nolan    false    250            �
           2606    196312 ,   session_activations session_activations_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT session_activations_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT session_activations_pkey;
       public         nolan    false    251            �
           2606    196314    settings settings_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pkey;
       public         nolan    false    253            �
           2606    196316    site_uploads site_uploads_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY site_uploads
    ADD CONSTRAINT site_uploads_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.site_uploads DROP CONSTRAINT site_uploads_pkey;
       public         nolan    false    255            �
           2606    196318    status_pins status_pins_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT status_pins_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT status_pins_pkey;
       public         nolan    false    257            �
           2606    196320    statuses statuses_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT statuses_pkey;
       public         nolan    false    259            �
           2606    196322 "   stream_entries stream_entries_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT stream_entries_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT stream_entries_pkey;
       public         nolan    false    262            �
           2606    196324     subscriptions subscriptions_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_pkey;
       public         nolan    false    264            �
           2606    196326    tags tags_pkey 
   CONSTRAINT     E   ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.tags DROP CONSTRAINT tags_pkey;
       public         nolan    false    266            �
           2606    196328    users users_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         nolan    false    268            �
           2606    196330 2   web_push_subscriptions web_push_subscriptions_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY web_push_subscriptions
    ADD CONSTRAINT web_push_subscriptions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.web_push_subscriptions DROP CONSTRAINT web_push_subscriptions_pkey;
       public         nolan    false    270            �
           2606    196332    web_settings web_settings_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT web_settings_pkey;
       public         nolan    false    272            �
           1259    196333    account_activity    INDEX     l   CREATE UNIQUE INDEX account_activity ON notifications USING btree (account_id, activity_id, activity_type);
 $   DROP INDEX public.account_activity;
       public         nolan    false    237    237    237            �
           1259    196334    hashtag_search_index    INDEX     ^   CREATE INDEX hashtag_search_index ON tags USING btree (lower((name)::text) text_pattern_ops);
 (   DROP INDEX public.hashtag_search_index;
       public         nolan    false    266    266            o
           1259    196335 4   index_account_domain_blocks_on_account_id_and_domain    INDEX     �   CREATE UNIQUE INDEX index_account_domain_blocks_on_account_id_and_domain ON account_domain_blocks USING btree (account_id, domain);
 H   DROP INDEX public.index_account_domain_blocks_on_account_id_and_domain;
       public         nolan    false    196    196            r
           1259    196336 ,   index_account_moderation_notes_on_account_id    INDEX     p   CREATE INDEX index_account_moderation_notes_on_account_id ON account_moderation_notes USING btree (account_id);
 @   DROP INDEX public.index_account_moderation_notes_on_account_id;
       public         nolan    false    198            s
           1259    196337 3   index_account_moderation_notes_on_target_account_id    INDEX     ~   CREATE INDEX index_account_moderation_notes_on_target_account_id ON account_moderation_notes USING btree (target_account_id);
 G   DROP INDEX public.index_account_moderation_notes_on_target_account_id;
       public         nolan    false    198            v
           1259    196338    index_accounts_on_uri    INDEX     B   CREATE INDEX index_accounts_on_uri ON accounts USING btree (uri);
 )   DROP INDEX public.index_accounts_on_uri;
       public         nolan    false    200            w
           1259    196339    index_accounts_on_url    INDEX     B   CREATE INDEX index_accounts_on_url ON accounts USING btree (url);
 )   DROP INDEX public.index_accounts_on_url;
       public         nolan    false    200            x
           1259    196340 %   index_accounts_on_username_and_domain    INDEX     f   CREATE UNIQUE INDEX index_accounts_on_username_and_domain ON accounts USING btree (username, domain);
 9   DROP INDEX public.index_accounts_on_username_and_domain;
       public         nolan    false    200    200            y
           1259    196341 +   index_accounts_on_username_and_domain_lower    INDEX     �   CREATE INDEX index_accounts_on_username_and_domain_lower ON accounts USING btree (lower((username)::text), lower((domain)::text));
 ?   DROP INDEX public.index_accounts_on_username_and_domain_lower;
       public         nolan    false    200    200    200            }
           1259    196342 %   index_admin_action_logs_on_account_id    INDEX     b   CREATE INDEX index_admin_action_logs_on_account_id ON admin_action_logs USING btree (account_id);
 9   DROP INDEX public.index_admin_action_logs_on_account_id;
       public         nolan    false    202            ~
           1259    196343 4   index_admin_action_logs_on_target_type_and_target_id    INDEX     }   CREATE INDEX index_admin_action_logs_on_target_type_and_target_id ON admin_action_logs USING btree (target_type, target_id);
 H   DROP INDEX public.index_admin_action_logs_on_target_type_and_target_id;
       public         nolan    false    202    202            �
           1259    196344 0   index_blocks_on_account_id_and_target_account_id    INDEX     |   CREATE UNIQUE INDEX index_blocks_on_account_id_and_target_account_id ON blocks USING btree (account_id, target_account_id);
 D   DROP INDEX public.index_blocks_on_account_id_and_target_account_id;
       public         nolan    false    205    205            �
           1259    196345 :   index_conversation_mutes_on_account_id_and_conversation_id    INDEX     �   CREATE UNIQUE INDEX index_conversation_mutes_on_account_id_and_conversation_id ON conversation_mutes USING btree (account_id, conversation_id);
 N   DROP INDEX public.index_conversation_mutes_on_account_id_and_conversation_id;
       public         nolan    false    207    207            �
           1259    196346    index_conversations_on_uri    INDEX     S   CREATE UNIQUE INDEX index_conversations_on_uri ON conversations USING btree (uri);
 .   DROP INDEX public.index_conversations_on_uri;
       public         nolan    false    209            �
           1259    196347 +   index_custom_emojis_on_shortcode_and_domain    INDEX     r   CREATE UNIQUE INDEX index_custom_emojis_on_shortcode_and_domain ON custom_emojis USING btree (shortcode, domain);
 ?   DROP INDEX public.index_custom_emojis_on_shortcode_and_domain;
       public         nolan    false    211    211            �
           1259    196348    index_domain_blocks_on_domain    INDEX     Y   CREATE UNIQUE INDEX index_domain_blocks_on_domain ON domain_blocks USING btree (domain);
 1   DROP INDEX public.index_domain_blocks_on_domain;
       public         nolan    false    213            �
           1259    196349 #   index_email_domain_blocks_on_domain    INDEX     e   CREATE UNIQUE INDEX index_email_domain_blocks_on_domain ON email_domain_blocks USING btree (domain);
 7   DROP INDEX public.index_email_domain_blocks_on_domain;
       public         nolan    false    215            �
           1259    196350 %   index_favourites_on_account_id_and_id    INDEX     _   CREATE INDEX index_favourites_on_account_id_and_id ON favourites USING btree (account_id, id);
 9   DROP INDEX public.index_favourites_on_account_id_and_id;
       public         nolan    false    217    217            �
           1259    196351 ,   index_favourites_on_account_id_and_status_id    INDEX     t   CREATE UNIQUE INDEX index_favourites_on_account_id_and_status_id ON favourites USING btree (account_id, status_id);
 @   DROP INDEX public.index_favourites_on_account_id_and_status_id;
       public         nolan    false    217    217            �
           1259    196352    index_favourites_on_status_id    INDEX     R   CREATE INDEX index_favourites_on_status_id ON favourites USING btree (status_id);
 1   DROP INDEX public.index_favourites_on_status_id;
       public         nolan    false    217            �
           1259    196353 9   index_follow_requests_on_account_id_and_target_account_id    INDEX     �   CREATE UNIQUE INDEX index_follow_requests_on_account_id_and_target_account_id ON follow_requests USING btree (account_id, target_account_id);
 M   DROP INDEX public.index_follow_requests_on_account_id_and_target_account_id;
       public         nolan    false    219    219            �
           1259    196354 1   index_follows_on_account_id_and_target_account_id    INDEX     ~   CREATE UNIQUE INDEX index_follows_on_account_id_and_target_account_id ON follows USING btree (account_id, target_account_id);
 E   DROP INDEX public.index_follows_on_account_id_and_target_account_id;
       public         nolan    false    221    221            �
           1259    196355    index_invites_on_code    INDEX     I   CREATE UNIQUE INDEX index_invites_on_code ON invites USING btree (code);
 )   DROP INDEX public.index_invites_on_code;
       public         nolan    false    225            �
           1259    196356    index_invites_on_user_id    INDEX     H   CREATE INDEX index_invites_on_user_id ON invites USING btree (user_id);
 ,   DROP INDEX public.index_invites_on_user_id;
       public         nolan    false    225            �
           1259    196357 -   index_list_accounts_on_account_id_and_list_id    INDEX     v   CREATE UNIQUE INDEX index_list_accounts_on_account_id_and_list_id ON list_accounts USING btree (account_id, list_id);
 A   DROP INDEX public.index_list_accounts_on_account_id_and_list_id;
       public         nolan    false    227    227            �
           1259    196358     index_list_accounts_on_follow_id    INDEX     X   CREATE INDEX index_list_accounts_on_follow_id ON list_accounts USING btree (follow_id);
 4   DROP INDEX public.index_list_accounts_on_follow_id;
       public         nolan    false    227            �
           1259    196359 -   index_list_accounts_on_list_id_and_account_id    INDEX     o   CREATE INDEX index_list_accounts_on_list_id_and_account_id ON list_accounts USING btree (list_id, account_id);
 A   DROP INDEX public.index_list_accounts_on_list_id_and_account_id;
       public         nolan    false    227    227            �
           1259    196360    index_lists_on_account_id    INDEX     J   CREATE INDEX index_lists_on_account_id ON lists USING btree (account_id);
 -   DROP INDEX public.index_lists_on_account_id;
       public         nolan    false    229            �
           1259    196361 %   index_media_attachments_on_account_id    INDEX     b   CREATE INDEX index_media_attachments_on_account_id ON media_attachments USING btree (account_id);
 9   DROP INDEX public.index_media_attachments_on_account_id;
       public         nolan    false    231            �
           1259    196362 $   index_media_attachments_on_shortcode    INDEX     g   CREATE UNIQUE INDEX index_media_attachments_on_shortcode ON media_attachments USING btree (shortcode);
 8   DROP INDEX public.index_media_attachments_on_shortcode;
       public         nolan    false    231            �
           1259    196363 $   index_media_attachments_on_status_id    INDEX     `   CREATE INDEX index_media_attachments_on_status_id ON media_attachments USING btree (status_id);
 8   DROP INDEX public.index_media_attachments_on_status_id;
       public         nolan    false    231            �
           1259    196364 *   index_mentions_on_account_id_and_status_id    INDEX     p   CREATE UNIQUE INDEX index_mentions_on_account_id_and_status_id ON mentions USING btree (account_id, status_id);
 >   DROP INDEX public.index_mentions_on_account_id_and_status_id;
       public         nolan    false    233    233            �
           1259    196365    index_mentions_on_status_id    INDEX     N   CREATE INDEX index_mentions_on_status_id ON mentions USING btree (status_id);
 /   DROP INDEX public.index_mentions_on_status_id;
       public         nolan    false    233            �
           1259    196366 /   index_mutes_on_account_id_and_target_account_id    INDEX     z   CREATE UNIQUE INDEX index_mutes_on_account_id_and_target_account_id ON mutes USING btree (account_id, target_account_id);
 C   DROP INDEX public.index_mutes_on_account_id_and_target_account_id;
       public         nolan    false    235    235            �
           1259    196367 (   index_notifications_on_account_id_and_id    INDEX     j   CREATE INDEX index_notifications_on_account_id_and_id ON notifications USING btree (account_id, id DESC);
 <   DROP INDEX public.index_notifications_on_account_id_and_id;
       public         nolan    false    237    237            �
           1259    196368 4   index_notifications_on_activity_id_and_activity_type    INDEX     }   CREATE INDEX index_notifications_on_activity_id_and_activity_type ON notifications USING btree (activity_id, activity_type);
 H   DROP INDEX public.index_notifications_on_activity_id_and_activity_type;
       public         nolan    false    237    237            �
           1259    196369 "   index_oauth_access_grants_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);
 6   DROP INDEX public.index_oauth_access_grants_on_token;
       public         nolan    false    239            �
           1259    196370 *   index_oauth_access_tokens_on_refresh_token    INDEX     s   CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);
 >   DROP INDEX public.index_oauth_access_tokens_on_refresh_token;
       public         nolan    false    241            �
           1259    196371 .   index_oauth_access_tokens_on_resource_owner_id    INDEX     t   CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);
 B   DROP INDEX public.index_oauth_access_tokens_on_resource_owner_id;
       public         nolan    false    241            �
           1259    196372 "   index_oauth_access_tokens_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);
 6   DROP INDEX public.index_oauth_access_tokens_on_token;
       public         nolan    false    241            �
           1259    196373 3   index_oauth_applications_on_owner_id_and_owner_type    INDEX     {   CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON oauth_applications USING btree (owner_id, owner_type);
 G   DROP INDEX public.index_oauth_applications_on_owner_id_and_owner_type;
       public         nolan    false    243    243            �
           1259    196374    index_oauth_applications_on_uid    INDEX     ]   CREATE UNIQUE INDEX index_oauth_applications_on_uid ON oauth_applications USING btree (uid);
 3   DROP INDEX public.index_oauth_applications_on_uid;
       public         nolan    false    243            �
           1259    196375    index_preview_cards_on_url    INDEX     S   CREATE UNIQUE INDEX index_preview_cards_on_url ON preview_cards USING btree (url);
 .   DROP INDEX public.index_preview_cards_on_url;
       public         nolan    false    245            �
           1259    196376 =   index_preview_cards_statuses_on_status_id_and_preview_card_id    INDEX     �   CREATE INDEX index_preview_cards_statuses_on_status_id_and_preview_card_id ON preview_cards_statuses USING btree (status_id, preview_card_id);
 Q   DROP INDEX public.index_preview_cards_statuses_on_status_id_and_preview_card_id;
       public         nolan    false    247    247            �
           1259    196377    index_reports_on_account_id    INDEX     N   CREATE INDEX index_reports_on_account_id ON reports USING btree (account_id);
 /   DROP INDEX public.index_reports_on_account_id;
       public         nolan    false    248            �
           1259    196378 "   index_reports_on_target_account_id    INDEX     \   CREATE INDEX index_reports_on_target_account_id ON reports USING btree (target_account_id);
 6   DROP INDEX public.index_reports_on_target_account_id;
       public         nolan    false    248            �
           1259    196379 '   index_session_activations_on_session_id    INDEX     m   CREATE UNIQUE INDEX index_session_activations_on_session_id ON session_activations USING btree (session_id);
 ;   DROP INDEX public.index_session_activations_on_session_id;
       public         nolan    false    251            �
           1259    196380 $   index_session_activations_on_user_id    INDEX     `   CREATE INDEX index_session_activations_on_user_id ON session_activations USING btree (user_id);
 8   DROP INDEX public.index_session_activations_on_user_id;
       public         nolan    false    251            �
           1259    196381 1   index_settings_on_thing_type_and_thing_id_and_var    INDEX     {   CREATE UNIQUE INDEX index_settings_on_thing_type_and_thing_id_and_var ON settings USING btree (thing_type, thing_id, var);
 E   DROP INDEX public.index_settings_on_thing_type_and_thing_id_and_var;
       public         nolan    false    253    253    253            �
           1259    196382    index_site_uploads_on_var    INDEX     Q   CREATE UNIQUE INDEX index_site_uploads_on_var ON site_uploads USING btree (var);
 -   DROP INDEX public.index_site_uploads_on_var;
       public         nolan    false    255            �
           1259    196383 -   index_status_pins_on_account_id_and_status_id    INDEX     v   CREATE UNIQUE INDEX index_status_pins_on_account_id_and_status_id ON status_pins USING btree (account_id, status_id);
 A   DROP INDEX public.index_status_pins_on_account_id_and_status_id;
       public         nolan    false    257    257            �
           1259    196384    index_statuses_20180106    INDEX     l   CREATE INDEX index_statuses_20180106 ON statuses USING btree (account_id, id DESC, visibility, updated_at);
 +   DROP INDEX public.index_statuses_20180106;
       public         nolan    false    259    259    259    259            �
           1259    196385 !   index_statuses_on_conversation_id    INDEX     Z   CREATE INDEX index_statuses_on_conversation_id ON statuses USING btree (conversation_id);
 5   DROP INDEX public.index_statuses_on_conversation_id;
       public         nolan    false    259            �
           1259    196386     index_statuses_on_in_reply_to_id    INDEX     X   CREATE INDEX index_statuses_on_in_reply_to_id ON statuses USING btree (in_reply_to_id);
 4   DROP INDEX public.index_statuses_on_in_reply_to_id;
       public         nolan    false    259            �
           1259    196387 -   index_statuses_on_reblog_of_id_and_account_id    INDEX     o   CREATE INDEX index_statuses_on_reblog_of_id_and_account_id ON statuses USING btree (reblog_of_id, account_id);
 A   DROP INDEX public.index_statuses_on_reblog_of_id_and_account_id;
       public         nolan    false    259    259            �
           1259    196388    index_statuses_on_uri    INDEX     I   CREATE UNIQUE INDEX index_statuses_on_uri ON statuses USING btree (uri);
 )   DROP INDEX public.index_statuses_on_uri;
       public         nolan    false    259            �
           1259    196389     index_statuses_tags_on_status_id    INDEX     X   CREATE INDEX index_statuses_tags_on_status_id ON statuses_tags USING btree (status_id);
 4   DROP INDEX public.index_statuses_tags_on_status_id;
       public         nolan    false    261            �
           1259    196390 +   index_statuses_tags_on_tag_id_and_status_id    INDEX     r   CREATE UNIQUE INDEX index_statuses_tags_on_tag_id_and_status_id ON statuses_tags USING btree (tag_id, status_id);
 ?   DROP INDEX public.index_statuses_tags_on_tag_id_and_status_id;
       public         nolan    false    261    261            �
           1259    196391 ;   index_stream_entries_on_account_id_and_activity_type_and_id    INDEX     �   CREATE INDEX index_stream_entries_on_account_id_and_activity_type_and_id ON stream_entries USING btree (account_id, activity_type, id);
 O   DROP INDEX public.index_stream_entries_on_account_id_and_activity_type_and_id;
       public         nolan    false    262    262    262            �
           1259    196392 5   index_stream_entries_on_activity_id_and_activity_type    INDEX        CREATE INDEX index_stream_entries_on_activity_id_and_activity_type ON stream_entries USING btree (activity_id, activity_type);
 I   DROP INDEX public.index_stream_entries_on_activity_id_and_activity_type;
       public         nolan    false    262    262            �
           1259    196393 2   index_subscriptions_on_account_id_and_callback_url    INDEX     �   CREATE UNIQUE INDEX index_subscriptions_on_account_id_and_callback_url ON subscriptions USING btree (account_id, callback_url);
 F   DROP INDEX public.index_subscriptions_on_account_id_and_callback_url;
       public         nolan    false    264    264            �
           1259    196394    index_tags_on_name    INDEX     C   CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);
 &   DROP INDEX public.index_tags_on_name;
       public         nolan    false    266            �
           1259    196395    index_users_on_account_id    INDEX     J   CREATE INDEX index_users_on_account_id ON users USING btree (account_id);
 -   DROP INDEX public.index_users_on_account_id;
       public         nolan    false    268            �
           1259    196396 !   index_users_on_confirmation_token    INDEX     a   CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);
 5   DROP INDEX public.index_users_on_confirmation_token;
       public         nolan    false    268            �
           1259    196397    index_users_on_email    INDEX     G   CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public         nolan    false    268            �
           1259    196398 !   index_users_on_filtered_languages    INDEX     X   CREATE INDEX index_users_on_filtered_languages ON users USING gin (filtered_languages);
 5   DROP INDEX public.index_users_on_filtered_languages;
       public         nolan    false    268            �
           1259    196399 #   index_users_on_reset_password_token    INDEX     e   CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);
 7   DROP INDEX public.index_users_on_reset_password_token;
       public         nolan    false    268            �
           1259    196400    index_web_settings_on_user_id    INDEX     Y   CREATE UNIQUE INDEX index_web_settings_on_user_id ON web_settings USING btree (user_id);
 1   DROP INDEX public.index_web_settings_on_user_id;
       public         nolan    false    272            z
           1259    196401    search_index    INDEX     C  CREATE INDEX search_index ON accounts USING gin ((((setweight(to_tsvector('simple'::regconfig, (display_name)::text), 'A'::"char") || setweight(to_tsvector('simple'::regconfig, (username)::text), 'B'::"char")) || setweight(to_tsvector('simple'::regconfig, (COALESCE(domain, ''::character varying))::text), 'C'::"char"))));
     DROP INDEX public.search_index;
       public         nolan    false    200    200    200    200            3           2606    196402    web_settings fk_11910667b2    FK CONSTRAINT     }   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT fk_11910667b2 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT fk_11910667b2;
       public       nolan    false    2810    272    268                        2606    196407 #   account_domain_blocks fk_206c6029bd    FK CONSTRAINT     �   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT fk_206c6029bd FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT fk_206c6029bd;
       public       nolan    false    2677    200    196                       2606    196412     conversation_mutes fk_225b4212bb    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_225b4212bb FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_225b4212bb;
       public       nolan    false    207    200    2677            -           2606    196417    statuses_tags fk_3081861e21    FK CONSTRAINT     |   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_3081861e21 FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_3081861e21;
       public       nolan    false    261    266    2803                       2606    196422    follows fk_32ed1b5560    FK CONSTRAINT     ~   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_32ed1b5560 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_32ed1b5560;
       public       nolan    false    221    200    2677                       2606    196427 !   oauth_access_grants fk_34d54b0a33    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_34d54b0a33 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_34d54b0a33;
       public       nolan    false    239    243    2760                       2606    196432    blocks fk_4269e03e65    FK CONSTRAINT     }   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_4269e03e65 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_4269e03e65;
       public       nolan    false    200    205    2677            "           2606    196437    reports fk_4b81f7522c    FK CONSTRAINT     ~   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_4b81f7522c FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_4b81f7522c;
       public       nolan    false    248    2677    200            1           2606    196442    users fk_50500f500d    FK CONSTRAINT     |   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_50500f500d FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_50500f500d;
       public       nolan    false    268    2677    200            /           2606    196447    stream_entries fk_5659b17554    FK CONSTRAINT     �   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT fk_5659b17554 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT fk_5659b17554;
       public       nolan    false    2677    200    262            	           2606    196452    favourites fk_5eb6c2b873    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_5eb6c2b873 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_5eb6c2b873;
       public       nolan    false    2677    217    200                       2606    196457 !   oauth_access_grants fk_63b044929b    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_63b044929b FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_63b044929b;
       public       nolan    false    268    239    2810                       2606    196462    imports fk_6db1b6e408    FK CONSTRAINT     ~   ALTER TABLE ONLY imports
    ADD CONSTRAINT fk_6db1b6e408 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.imports DROP CONSTRAINT fk_6db1b6e408;
       public       nolan    false    223    200    2677                       2606    196467    follows fk_745ca29eac    FK CONSTRAINT     �   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_745ca29eac FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_745ca29eac;
       public       nolan    false    200    221    2677                       2606    196472    follow_requests fk_76d644b0e7    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_76d644b0e7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_76d644b0e7;
       public       nolan    false    219    200    2677                       2606    196477    follow_requests fk_9291ec025d    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_9291ec025d FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_9291ec025d;
       public       nolan    false    219    200    2677                       2606    196482    blocks fk_9571bfabc1    FK CONSTRAINT     �   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_9571bfabc1 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_9571bfabc1;
       public       nolan    false    200    205    2677            %           2606    196487 !   session_activations fk_957e5bda89    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_957e5bda89 FOREIGN KEY (access_token_id) REFERENCES oauth_access_tokens(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_957e5bda89;
       public       nolan    false    251    241    2756                       2606    196492    media_attachments fk_96dd81e81b    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_96dd81e81b FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_96dd81e81b;
       public       nolan    false    231    2677    200                       2606    196497    mentions fk_970d43f9d1    FK CONSTRAINT        ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_970d43f9d1 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_970d43f9d1;
       public       nolan    false    200    233    2677            0           2606    196502    subscriptions fk_9847d1cbb5    FK CONSTRAINT     �   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_9847d1cbb5 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT fk_9847d1cbb5;
       public       nolan    false    2677    200    264            )           2606    196507    statuses fk_9bda1543f7    FK CONSTRAINT        ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_9bda1543f7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_9bda1543f7;
       public       nolan    false    259    2677    200            !           2606    196512     oauth_applications fk_b0988c7c0a    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT fk_b0988c7c0a FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT fk_b0988c7c0a;
       public       nolan    false    268    243    2810            
           2606    196517    favourites fk_b0e856845e    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_b0e856845e FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_b0e856845e;
       public       nolan    false    2790    217    259                       2606    196522    mutes fk_b8d8daf315    FK CONSTRAINT     |   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_b8d8daf315 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_b8d8daf315;
       public       nolan    false    200    235    2677            #           2606    196527    reports fk_bca45b75fd    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_bca45b75fd FOREIGN KEY (action_taken_by_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_bca45b75fd;
       public       nolan    false    200    248    2677                       2606    196532    notifications fk_c141c8ee55    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_c141c8ee55 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_c141c8ee55;
       public       nolan    false    2677    200    237            *           2606    196537    statuses fk_c7fa917661    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_c7fa917661 FOREIGN KEY (in_reply_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_c7fa917661;
       public       nolan    false    200    259    2677            '           2606    196542    status_pins fk_d4cb435b62    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_d4cb435b62 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_d4cb435b62;
       public       nolan    false    257    2677    200            &           2606    196547 !   session_activations fk_e5fda67334    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_e5fda67334 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_e5fda67334;
       public       nolan    false    268    2810    251                       2606    196552 !   oauth_access_tokens fk_e84df68546    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_e84df68546 FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_e84df68546;
       public       nolan    false    268    241    2810            $           2606    196557    reports fk_eb37af34f0    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_eb37af34f0 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_eb37af34f0;
       public       nolan    false    248    2677    200                       2606    196562    mutes fk_eecff219ea    FK CONSTRAINT     �   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_eecff219ea FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_eecff219ea;
       public       nolan    false    200    235    2677                        2606    196567 !   oauth_access_tokens fk_f5fc4c1ee3    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_f5fc4c1ee3 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_f5fc4c1ee3;
       public       nolan    false    241    2760    243                       2606    196572    notifications fk_fbd6b0bf9e    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_fbd6b0bf9e FOREIGN KEY (from_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_fbd6b0bf9e;
       public       nolan    false    200    2677    237                       2606    196577    accounts fk_rails_2320833084    FK CONSTRAINT     �   ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_rails_2320833084 FOREIGN KEY (moved_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.accounts DROP CONSTRAINT fk_rails_2320833084;
       public       nolan    false    2677    200    200            +           2606    196582    statuses fk_rails_256483a9ab    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_256483a9ab FOREIGN KEY (reblog_of_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_256483a9ab;
       public       nolan    false    259    259    2790                       2606    196587    lists fk_rails_3853b78dac    FK CONSTRAINT     �   ALTER TABLE ONLY lists
    ADD CONSTRAINT fk_rails_3853b78dac FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.lists DROP CONSTRAINT fk_rails_3853b78dac;
       public       nolan    false    200    2677    229                       2606    196592 %   media_attachments fk_rails_3ec0cfdd70    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_rails_3ec0cfdd70 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_rails_3ec0cfdd70;
       public       nolan    false    259    2790    231                       2606    196597 ,   account_moderation_notes fk_rails_3f8b75089b    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_3f8b75089b FOREIGN KEY (account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_3f8b75089b;
       public       nolan    false    200    2677    198                       2606    196602 !   list_accounts fk_rails_40f9cc29f1    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_40f9cc29f1 FOREIGN KEY (follow_id) REFERENCES follows(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_40f9cc29f1;
       public       nolan    false    227    221    2716                       2606    196607    mentions fk_rails_59edbe2887    FK CONSTRAINT     �   ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_rails_59edbe2887 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_rails_59edbe2887;
       public       nolan    false    2790    259    233                       2606    196612 &   conversation_mutes fk_rails_5ab139311f    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_rails_5ab139311f FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_rails_5ab139311f;
       public       nolan    false    2696    209    207            (           2606    196617    status_pins fk_rails_65c05552f1    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_rails_65c05552f1 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_rails_65c05552f1;
       public       nolan    false    257    259    2790                       2606    196622 !   list_accounts fk_rails_85fee9d6ab    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_85fee9d6ab FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_85fee9d6ab;
       public       nolan    false    2677    227    200            2           2606    196627    users fk_rails_8fb2a43e88    FK CONSTRAINT     �   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_8fb2a43e88 FOREIGN KEY (invite_id) REFERENCES invites(id) ON DELETE SET NULL;
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_rails_8fb2a43e88;
       public       nolan    false    268    2723    225            ,           2606    196632    statuses fk_rails_94a6f70399    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_94a6f70399 FOREIGN KEY (in_reply_to_id) REFERENCES statuses(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_94a6f70399;
       public       nolan    false    259    259    2790                       2606    196637 %   admin_action_logs fk_rails_a7667297fa    FK CONSTRAINT     �   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT fk_rails_a7667297fa FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT fk_rails_a7667297fa;
       public       nolan    false    2677    200    202                       2606    196642 ,   account_moderation_notes fk_rails_dd62ed5ac3    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_dd62ed5ac3 FOREIGN KEY (target_account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_dd62ed5ac3;
       public       nolan    false    200    198    2677            .           2606    196647 !   statuses_tags fk_rails_df0fe11427    FK CONSTRAINT     �   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_rails_df0fe11427 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_rails_df0fe11427;
       public       nolan    false    2790    259    261                       2606    196652 !   list_accounts fk_rails_e54e356c88    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_e54e356c88 FOREIGN KEY (list_id) REFERENCES lists(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_e54e356c88;
       public       nolan    false    2731    229    227                       2606    196657    invites fk_rails_ff69dbb2ac    FK CONSTRAINT     ~   ALTER TABLE ONLY invites
    ADD CONSTRAINT fk_rails_ff69dbb2ac FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.invites DROP CONSTRAINT fk_rails_ff69dbb2ac;
       public       nolan    false    225    2810    268            �      x������ � �      �      x������ � �      �      x���W��ʙv����K�G��� Ü���0�9H̿��>�m�n�=��n@Սb�[�ZO	�QC�<�?�����l�t��Oˑ=���T���+�^�e~x�M�,m���wc�{�/CN�T=�P��/A�@�����[Sq����g�~���H:�lt15�&�_�ӎ�l�)��lP��� \�->�`�e={��>����V��}��X�#��q�a��y�� xox���D��(l�z�E�}��Җȗ��U͡k��Iv�Շ�2�g�`�`��Ms�.`���	�������OQQ�h� ��!	m7�MG�k�ضg`	��Xͼ8����rW��*y�oe�[s��.��J!��=��M/v6��m���k��S�r����H��ӸX�h#5bI�9���)!�,i%���Q�a)R(H��)XC�}D���&�,2t{B�6�����2��e��p�P��Q��e^�.��-B0]��[7��P���͢�W�,�EjXF����X�P��[�X#�T�<���ېy	�ZX-��۹�u3;|�k�#:�|MIBW�Ȏ4�H����N�zo�����I���j,�
HL���L���>gAc!�[��d��Z��h��UCh�^i��%<�
yԹtmV��Z����8nP���$LV����Z� /$�)��Ck1�g/�f�Io>��bH�t�O*���N�I"������ ������Z-�1sPj������� -�����%ec��kPV#�;��B��c�@��Mr���1�wx~�1A:��JuC�0O��&�7+�?������vK.5 ���:�����LP$]c^5z�<37Q��"S7gԨ�4���D  2�H�s�1��U�k5ӝ�kφ�k�Azz|N���1H��N(�+�רi�`�	����P����Ͼ�f|0K �^���7� ˻>���SL�S�z�z�JAqU��j��}��}����Tǽ��7N�R:ӂz�dLA�7�k� ��(y�b��De5�O�A��>�n=�?�Q�ʼx6ް�;7��yd��4�	~�p	��o�^�	�{�!�J�\�0�{X(�`���<�Sֹ���lG�4�q���ܚ��<�������mM���cοn��V^C�G�_���Y�kde8$ѻr��_�C�9�Q4�M���l��-i`_<ݘ�c��,�/���^�6!O�i_�Z�9�Ğ�(���m���ǰ҂�=Q�M�����C\�d�lF1�� �^�k��f�]lQ� ��Rm�+��m��h2W��=�;*��������	��S�{�5���b�6�W3�M%R�\��q^�"�_���?�׳��_ߡ׳��_ߡ׳��_ߡ׳��_ߡ׳��_ߡ�u�ï�Zѿ[��!� �G�	"��?��oc8�ե�q9��?������~7�����? ?�eٿ�=���Y�l�,
b{�,Z�}�a�p-n߷7UR��9v�`Q%]��q(�?�l@��ZK�:��O�$�M��`��4ie��]�W�c���������NC��oz���>�.�j(�s�^#sX4�TH'�&.7D8�L�x�	:7���DqdB@�>Ǌ6uu���Eq ima���Ӆ���AK��`P��LYNwp��	�Z+�� �t���+��w�$ #'d8��Xʃw6}��D�W�^;��	~��j={2Jcvj�@��{^��q⬪�,���Z{l�!�\�9�>1���1غ������$�ij7�\sX�v�W��q�Sx�.<�&Ns�+&�q�� ���̏k�6&�KY�=��ӕ���(&Y� �D`��C�{M�4Y2)�E�:�3 ��P�M�,;ѽ�����2�zzZ�t('� ��ʅl#id��MF�K�F��d&/<k��uI5!LQh���fI#B�k���!H��1�&z�m�����p��b���.�'訌me�����$���I�%h�L�c�Jӌ`9 ���զP?���/H0���1p]z� �2�a��H��߮wJ��G�ب����S��ɳ��G�$��a�A%xM�$,Q�����b�qk��9_էfdy�d^�	ox�^wY�/�nIR����c�ou@}'N�[�	KțO�1Z�J���g��°��n~D���(5U̡�-�Ͳ�4"ő�DJ+�o�x��Q��,6�������)<��l?gk��Pp2���{'>��{��ʠC�IĀT�ؔϠ�(Q��yiO(�����r��@bխ6��G}a�"�qi����7!�����E�^ؼ�kx�kX�H�=�I��rʇ�\�E���i\2T���9������J�Vj��lI({+T��	rRV�����%�r:p����+����r�@�e`����ݓ`u�Czt/�c�K
�k�������"W�EX`�ۧH�V=v�,�p.0�]/�u%7�=Ϊ��~�`���񳟽dU�h54�H�Y�U� ��}w~�S�j#����x�e�]�ݜŪw��7��0�����H��#E�D�s�!>	�;���Ϟڲ)V�<�^�Mt{�/���pIx9G���8'	:�|��N�����^�)�wO�	�m;�̚�lȂ���P�!Ӈc�3 �jk3�s��8���Lz����+`V�P(�'��%�`5�Yƻb9�Ou��̧j����8[-�UL�:��P}����W����W������a�!س��a�!�%._0�;��ܿ�>�Ja	u���>Џ8��_8����>S��'�dG����<d�-��:=t���g�&���ќE�5�{/3y�]H����[��0���+�	�(��mS:���%臀P�.�eŮ������ɀRD����a7⸝m�
Oq��v&E�(�E����Y��MJ�����T�k���˃�AG��]u��xe�'/�m�V���( �ZjD�O��٩.B��eps؂����5�b��=0D�?:{*C\�3�2��1�I;Nјm�,�����W����@i�=hw��S�j�_�]�����H��o�G�o�0�]HV���ŭ��߱1�+f��G��W0@-�c#"����<���@6j�.xL�ؼ{_�S�Xgx
�E���t5W��� %�����d��yS*���e�29s�JG8|/����=�ǆF�;�m�ǭ����W)$�=zě�,ZQ$��힔LL�z��'s�Q]�J���荐��Ӎ��)���H�9y`�1�Gz�֤��f�C��Ar��] _ctA�؊
��؆}Y۾D�8�(�K�!��4�wuh��wB��{�)�)��	�ў˯��`�-%��*+���ZL]��Ḧ�˦��w�n��Y�%2ƭ1�v�W(5rV����Ҝ�0��"0��+����kq�����kʵ6�+�{�5���x�O�vE�y�P]ԣ�sYt�PA0��VT��c��k5�Z<��
ƱV��}�����\�-�s����i��e#L^��jU����ǡ+��Lafp�� l;�^���ů��_.��MpӹU���+�*������^�w��3�3�ØD]�K=�m��s���>����[���a��,�v��n�h�5K,7�@�]�s]���
ުjO�S0˩�B�b>8E�Kt��|�'A=30v���'�t�@�9�&U���WVv���;��б��c��U�x�� ���G��W��O4��/�`���
$����s�*�����1�M�݆��t�zV�'�%D�a~�vw'yl��(c���|�"yCճ���MX�H��X�	�+���E3b<F���+��حb.�.a�_�tЇv>3m)��k����xc��QW��G��:��5�8��� �>�����*�`%�H/Ia�m� u����|��0VmZ-L�Rz��ˬ�Qҫ\��/��)���y'����
��i1����QW�_>�`b@P�E�s/w��S��#�Y��]9U�f��|UDD������#z]���C�_��������W�����W�������_ߡׯ#��{�?��o�B�������{���o����s���V���� m  /������`ƻ-te{��P�&�Qa76úN�b���%�[���kOy$�a�{�T�sh��4ͫ's������1U��g��@���|��ۈ�6���nŎ5���|7S(�w�Q�L݂��0éAH��*,&��͖��C�D�Ͼ4��-�k׾P�}�=N���¯zq00����t~�/
�kj�{���2]�A�~��Si�7j 얳0�Z� �%���Y"����BvP��֊�Sc_�Љq|�D���N���)c��A��ҋ�����嘘y�Zq��%�޳+x��Qߞ�{Yf,�M1�S1.uѪ9i G�g���y쩾4�C��!;�����ha�*�G�:JvLHO�A�*���TD�l;Fż�{l*s�W�W��G0�hx8Of{��"�Şcv���2��T<�?Х/D�	%�d0�T]ɕ�>_���<R���.$r4;@��$"���1iF���~=ˊ�_��>����ko�$�`����1m6�t4'2�>ٽ��[���GG��T�3Ը��-`�ۑ�g�~��W���C�XZ�'#��������t|�]��Z�w ��9:q�y�M~�L�lNf�/J� �A� �qL�@[�c.n���͐�꤈/4��E�7�^��e�HB�����N�+W�����u��$���Z� c�h
Q�����Sp���o�f�ȗ���/�:�mx}*)G�A��V�N�\��\l���y�h�@e�����b/dK�B̄D�넑��S��AT4㠰����N�;� �z���L�^:(f[D�%��U�!h"(	�j��B�������4��wt�[l�g�]�k&Փs��C@NHc�X���������ף
���*ǅ�@�5� 6����� �\�\�nկ*�r/o�n{U�t�w�^(�t)��Hͫ�8�[�Sa��5�LN�;8uu���3�ڋ����c����������,V~h�˵`G=�__ɿG[u�;q.ޠ��l�k�Xw�e��L&����0�� �n��;��h�#�M{�v��k\�6�iG���@��/>�tY�uuy�IF��~��0�slY�1���^�__Be��lfk��~����/��}��s@'�ך��k�?b}�X�[�k)�ko��Ժ^�=��"U���	�����������w�� Ez��eE���Q��\��Xcm%�F:*��1�	�]�Ce�1_�+�]"e����<��G����}�`��+�}�`��+�}�`W}�����Ű�������:�����3 �O0�J�J�`�<m~�������ۭ��D�!�߆��g�g?�_�~��������q�~���/�~V����xWy����Ԇ���.=������I��      �   �  x�ݔ�J�@����Xo������;�@E�@�a�[�ݐl}z'-���*�v��?3߆Mؤ�T���f�mn���}?5�������Ε�R��-�����l�k#	���EeϺV�ɛ-QК�u���)�2�ޢb�n��ս��cT$���V��r'�E7�S[,T��u������Iy�������BWJr��L�|�H�eQ�\PJ��(�����׽	Y�y������rz\�V�<�0�5�D�ю�+��aH͏656��q�������=��ޜ�S�ux��co�רʹ�Z]��N�X3�7� J!>���~<�O�O�^�㉢��1��D'HF�p��ߠsib*D���\�5��)��	:���6G�D͉�N��N�@:��[�Z8�p"������8W,�H��4�<�!{�M      �   >   x�K�+�,���M�+�LI-K��/ ��-t�u���L�L����MM-q�p��qqq �      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�}�Y
�0E��Ut�o�d����Ji��Ɩ� ���=<�k��vy��e5��xm�kB��
�{A����8���3l�9C�u2�"��s�HygQ#�8 (r��E���g(K�wx���C��G0>�*N�0��f��^F١QR��]�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   L   x�}˻�0 �����<���������c����!].Kr����	^��x�,��.�/�?a��꒝{OD� U8#B      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   X   x�}��� ѳ]E y��[@�H	H�~h ��=i �g�1?���`�25��'Z�n'�D�X)'����f�ʑ`�v"ȭoT��>)�      �      x������ � �      �   
  x�u�KjA���)|R��s���u�C r��"K�֫*�VV��z, ��-[�A��<�s᜞�A�!
�ml���k�~��ހN��eܾW�����g�������p�mՅ��kN ��L�h�� C!��!m"��%tR[��S��v`���ǝ��������Y���	)m�Q�j�۸&�uu�-	`M� �-n'�᪬����7�$N9����9@s����
�wJ���Z0h�y�[�O�î�d/q�Ǿ���{      �   �   x�}�Mj�0@�s�\`�d�G�!f��ld[j�B�\���o��0|XT�D��6����Q�$�;#�̵�a�̬���N��h�����8��6M*�����I|dMs�N��t�$�B4�j�}|���ޮ϶���jq���=�s���i���~��7���eh�7����3<�-�mY�^�A�      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�U�[��0D��bF<m����:�p\N��n�t\@ALt��s������墩�N����|q�M����
'�[>?)����=�+��	�7r�?7�C
�]�T��E:��Oմ�,�O���\�s8<cS]*��eC3��P�{S<�E����#�e�� �l.'�SUd`̰A��!N,5Ym"��sX%t�)Nl�É�ųSX`���v��7���#..G��͒�ŕ�O���qӼ��͋�u�G�մ�|jmCa�C����߃�o�zJ�ZQ>/B	��~��EǓ�F����\���َ}Rh�n0#A�i9��+���з������#��;G���-������0��F����`�u#�(�#)'#Go�4a���A�>��oF�����A�cs�E���h��,읺�V�$�=�Ԍ�I� ���y�BnGS�"�/cd�-gSzn5RfoB�]3�� $�[�3\o��D>l��c�Ş�[�^�ױ=��� <��X��B]�'%�g�����G��83�������c�+qh�W/����ȵ'h���S����C�Z|�[�����P�2X@iĩ��b(8ǲh�^���{��q��-��#�"�'c��u�{ђD����nG����T9��`��A�@���l���xF�|���������{��LJ��l*�^׍�{�Ut�-�O�bHw�e�ڔ�;z�W}��0�Y���nw�Ze��/���8��ګ�v������*K��      �   S  x���=K1��:�+Rށfg&������P�B8�IWW�C�_oD�8,%��2a.p ,�:ֆ����E��K��]л`%��pN��[�rz�16F��/c7��ݞ<yܔQ�yq)o$�Bړ��xyT����o�^��ú��k��SP
,n�g$J��B�ܓÎ�K�������cAn�m)l�ٖ���
ier��i,ץ;6��Ni+��W˳9��S��w��4�+B�'��������5��HUY�Zdg���mH�$�u	�p�7ĵ�[6�oK�����Y�Lɳ��u�	���xԐS�!��8�-�#We5ު�l��^��      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   F  x���[s�@�k���m��g��)���4�� @A������b�I5�;�;����.T��za�����?��c��2��� ay��-��1X�@gJPr�P�CB��n����fƟ�0�6�u��{ۉ�hK�|�y�N�$ҫN��=T}���=��qh٣�o���C�\�0���Oo+;a��d:��	O��UF�\G���@$�ôǋ��_��x��G�i��́6Y.mk��4�u��g	5�0(ҥRD�I�͇��d`��͝Q-�	�����E�<�j���m�2͇�~c�<C�}t���~�bՕ$�YEö��&I���`'��Ϩ�넩O,8R�:2������ݗ���I`�|0�b�`R*r2^t�Mk��Z��~�DŶ��Eaj� E�8�*��֨f/�|Y.e���������kH/N�Y�-�8���;4[vr[zh��j%s]  �a'�4�bב�	k�(�_(#�*�S��YEXi��7#�K|R�yÜ�*���rW2��1�k{�-���?���S��Ҙ��
�� ��ާ	g����n�$��ғ
�Br��Q��_1T�TpƓ�ON�z.��^xC�      �      x������ � �      �   �  x��Mo�0��ͯtɦ�r�ˡ̀�� YTk̶�^W����]����Q/���J��Y�|r}���C?Ҝ����&uĖbήR��=�]�����ty_�Ӷ��=��%}��|
Ye��.u�+7ԩ;\C�p�bj�t}ϊ�[�z�G��V-u��Í^GIc^�ɜ*������팞��v�M]�2]�fl�}ڳ:��>�/ޱ9ǣ�L��e	"��J�q�]Q���];�(S�P�gO8A2�X�
P9Õ�W%�>
z�s�ެޯN�nV��G`ᵕ�H� hM ��2:�ATA���/������p\J��f!J΍x)%f���;����Et2oS � &�͖�u�w<�?�,�N`AX����L���5�����Ue�(��.D����8H�j0�y_�βz�j�M��}15����f? �k��     