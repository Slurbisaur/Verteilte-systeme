PGDMP         :                y           stonksDB    13.3    13.3 5    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                        1262    16394    stonksDB    DATABASE     o   CREATE DATABASE "stonksDB" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United Kingdom.1252';
    DROP DATABASE "stonksDB";
                postgres    false            ?            1259    17124 
   developers    TABLE     ?   CREATE TABLE public.developers (
    devid integer NOT NULL,
    dev_name character varying(30) NOT NULL,
    publisher_id integer NOT NULL
);
    DROP TABLE public.developers;
       public         heap    postgres    false            ?            1259    17159    dlc    TABLE     ?   CREATE TABLE public.dlc (
    gameid integer NOT NULL,
    dlc_name character varying(30) NOT NULL,
    price numeric(10,2),
    currency character(3)
);
    DROP TABLE public.dlc;
       public         heap    postgres    false            ?            1259    17192 
   dlcs_owned    TABLE     ?   CREATE TABLE public.dlcs_owned (
    stonksid integer NOT NULL,
    gameid integer NOT NULL,
    dlc_name character varying(30) NOT NULL
);
    DROP TABLE public.dlcs_owned;
       public         heap    postgres    false            ?            1259    17134    games    TABLE     ?   CREATE TABLE public.games (
    gameid integer NOT NULL,
    game_name character varying(30) NOT NULL,
    genreid integer,
    devid integer,
    price numeric(10,2),
    currency character(3)
);
    DROP TABLE public.games;
       public         heap    postgres    false            ?            1259    17177    games_owned    TABLE     `   CREATE TABLE public.games_owned (
    stonksid integer NOT NULL,
    gameid integer NOT NULL
);
    DROP TABLE public.games_owned;
       public         heap    postgres    false            ?            1259    17111    genres    TABLE     c   CREATE TABLE public.genres (
    genreid integer NOT NULL,
    genre_name character varying(30)
);
    DROP TABLE public.genres;
       public         heap    postgres    false            ?            1259    17207    playtime    TABLE     y   CREATE TABLE public.playtime (
    stonksid integer NOT NULL,
    gameid integer NOT NULL,
    playtime_hours integer
);
    DROP TABLE public.playtime;
       public         heap    postgres    false            ?            1259    17226    playtime_total    VIEW     ?   CREATE VIEW public.playtime_total AS
 SELECT sum(playtime.playtime_hours) AS sum,
    playtime.gameid
   FROM public.playtime
  GROUP BY playtime.gameid;
 !   DROP VIEW public.playtime_total;
       public          postgres    false    210    210            ?            1259    17171    users    TABLE        CREATE TABLE public.users (
    stonksid integer NOT NULL,
    uname character varying(30) NOT NULL,
    fav_gameid integer
);
    DROP TABLE public.users;
       public         heap    postgres    false            ?            1259    17222    playtime_with_text    VIEW     0  CREATE VIEW public.playtime_with_text AS
 SELECT users.stonksid,
    users.uname,
    games.gameid,
    games.game_name,
    playtime.playtime_hours
   FROM ((public.playtime
     JOIN public.users ON ((playtime.stonksid = users.stonksid)))
     JOIN public.games ON ((playtime.gameid = games.gameid)));
 %   DROP VIEW public.playtime_with_text;
       public          postgres    false    207    204    210    210    210    204    207            ?            1259    17118 
   publishers    TABLE     s   CREATE TABLE public.publishers (
    publisher_id integer NOT NULL,
    pub_name character varying(30) NOT NULL
);
    DROP TABLE public.publishers;
       public         heap    postgres    false            ?            1259    17116    publishers_publisher_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.publishers_publisher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.publishers_publisher_id_seq;
       public          postgres    false    202                       0    0    publishers_publisher_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.publishers_publisher_id_seq OWNED BY public.publishers.publisher_id;
          public          postgres    false    201            ?            1259    17169    users_stonksid_seq    SEQUENCE     ?   CREATE SEQUENCE public.users_stonksid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.users_stonksid_seq;
       public          postgres    false    207                       0    0    users_stonksid_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_stonksid_seq OWNED BY public.users.stonksid;
          public          postgres    false    206            L           2604    17121    publishers publisher_id    DEFAULT     ?   ALTER TABLE ONLY public.publishers ALTER COLUMN publisher_id SET DEFAULT nextval('public.publishers_publisher_id_seq'::regclass);
 F   ALTER TABLE public.publishers ALTER COLUMN publisher_id DROP DEFAULT;
       public          postgres    false    202    201    202            M           2604    17174    users stonksid    DEFAULT     p   ALTER TABLE ONLY public.users ALTER COLUMN stonksid SET DEFAULT nextval('public.users_stonksid_seq'::regclass);
 =   ALTER TABLE public.users ALTER COLUMN stonksid DROP DEFAULT;
       public          postgres    false    206    207    207            ?          0    17124 
   developers 
   TABLE DATA           C   COPY public.developers (devid, dev_name, publisher_id) FROM stdin;
    public          postgres    false    203   ?       ?          0    17159    dlc 
   TABLE DATA           @   COPY public.dlc (gameid, dlc_name, price, currency) FROM stdin;
    public          postgres    false    205   ??       ?          0    17192 
   dlcs_owned 
   TABLE DATA           @   COPY public.dlcs_owned (stonksid, gameid, dlc_name) FROM stdin;
    public          postgres    false    209   ?@       ?          0    17134    games 
   TABLE DATA           S   COPY public.games (gameid, game_name, genreid, devid, price, currency) FROM stdin;
    public          postgres    false    204   SA       ?          0    17177    games_owned 
   TABLE DATA           7   COPY public.games_owned (stonksid, gameid) FROM stdin;
    public          postgres    false    208   MB       ?          0    17111    genres 
   TABLE DATA           5   COPY public.genres (genreid, genre_name) FROM stdin;
    public          postgres    false    200   ?B       ?          0    17207    playtime 
   TABLE DATA           D   COPY public.playtime (stonksid, gameid, playtime_hours) FROM stdin;
    public          postgres    false    210   C       ?          0    17118 
   publishers 
   TABLE DATA           <   COPY public.publishers (publisher_id, pub_name) FROM stdin;
    public          postgres    false    202   ?C       ?          0    17171    users 
   TABLE DATA           <   COPY public.users (stonksid, uname, fav_gameid) FROM stdin;
    public          postgres    false    207   	D                  0    0    publishers_publisher_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.publishers_publisher_id_seq', 1, false);
          public          postgres    false    201                       0    0    users_stonksid_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.users_stonksid_seq', 1, false);
          public          postgres    false    206            S           2606    17128    developers developers_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_pkey PRIMARY KEY (devid);
 D   ALTER TABLE ONLY public.developers DROP CONSTRAINT developers_pkey;
       public            postgres    false    203            W           2606    17163    dlc dlc_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.dlc
    ADD CONSTRAINT dlc_pkey PRIMARY KEY (gameid, dlc_name);
 6   ALTER TABLE ONLY public.dlc DROP CONSTRAINT dlc_pkey;
       public            postgres    false    205    205            ]           2606    17196    dlcs_owned dlcs_owned_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.dlcs_owned
    ADD CONSTRAINT dlcs_owned_pkey PRIMARY KEY (stonksid, gameid, dlc_name);
 D   ALTER TABLE ONLY public.dlcs_owned DROP CONSTRAINT dlcs_owned_pkey;
       public            postgres    false    209    209    209            [           2606    17181    games_owned games_owned_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.games_owned
    ADD CONSTRAINT games_owned_pkey PRIMARY KEY (stonksid, gameid);
 F   ALTER TABLE ONLY public.games_owned DROP CONSTRAINT games_owned_pkey;
       public            postgres    false    208    208            U           2606    17138    games games_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (gameid);
 :   ALTER TABLE ONLY public.games DROP CONSTRAINT games_pkey;
       public            postgres    false    204            O           2606    17115    genres genres_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (genreid);
 <   ALTER TABLE ONLY public.genres DROP CONSTRAINT genres_pkey;
       public            postgres    false    200            _           2606    17211    playtime playtime_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.playtime
    ADD CONSTRAINT playtime_pkey PRIMARY KEY (stonksid, gameid);
 @   ALTER TABLE ONLY public.playtime DROP CONSTRAINT playtime_pkey;
       public            postgres    false    210    210            Q           2606    17123    publishers publishers_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.publishers
    ADD CONSTRAINT publishers_pkey PRIMARY KEY (publisher_id);
 D   ALTER TABLE ONLY public.publishers DROP CONSTRAINT publishers_pkey;
       public            postgres    false    202            Y           2606    17176    users users_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (stonksid);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    207            `           2606    17129 '   developers developers_publisher_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES public.developers(devid) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.developers DROP CONSTRAINT developers_publisher_id_fkey;
       public          postgres    false    203    203    2899            e           2606    17164    dlc dlc_gameid_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.dlc
    ADD CONSTRAINT dlc_gameid_fkey FOREIGN KEY (gameid) REFERENCES public.games(gameid) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.dlc DROP CONSTRAINT dlc_gameid_fkey;
       public          postgres    false    2901    204    205            i           2606    17202 !   dlcs_owned dlcs_owned_gameid_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.dlcs_owned
    ADD CONSTRAINT dlcs_owned_gameid_fkey FOREIGN KEY (gameid) REFERENCES public.games(gameid) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.dlcs_owned DROP CONSTRAINT dlcs_owned_gameid_fkey;
       public          postgres    false    209    2901    204            h           2606    17197 #   dlcs_owned dlcs_owned_stonksid_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.dlcs_owned
    ADD CONSTRAINT dlcs_owned_stonksid_fkey FOREIGN KEY (stonksid) REFERENCES public.users(stonksid) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.dlcs_owned DROP CONSTRAINT dlcs_owned_stonksid_fkey;
       public          postgres    false    209    2905    207            b           2606    17144    games games_devid_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_devid_fkey FOREIGN KEY (devid) REFERENCES public.developers(devid) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.games DROP CONSTRAINT games_devid_fkey;
       public          postgres    false    204    203    2899            d           2606    17154    games games_devid_fkey1    FK CONSTRAINT     |   ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_devid_fkey1 FOREIGN KEY (devid) REFERENCES public.developers(devid);
 A   ALTER TABLE ONLY public.games DROP CONSTRAINT games_devid_fkey1;
       public          postgres    false    203    204    2899            a           2606    17139    games games_genreid_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_genreid_fkey FOREIGN KEY (genreid) REFERENCES public.genres(genreid) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.games DROP CONSTRAINT games_genreid_fkey;
       public          postgres    false    2895    204    200            c           2606    17149    games games_genreid_fkey1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_genreid_fkey1 FOREIGN KEY (genreid) REFERENCES public.genres(genreid);
 C   ALTER TABLE ONLY public.games DROP CONSTRAINT games_genreid_fkey1;
       public          postgres    false    200    2895    204            g           2606    17187 #   games_owned games_owned_gameid_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.games_owned
    ADD CONSTRAINT games_owned_gameid_fkey FOREIGN KEY (gameid) REFERENCES public.games(gameid) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.games_owned DROP CONSTRAINT games_owned_gameid_fkey;
       public          postgres    false    208    2901    204            f           2606    17182 %   games_owned games_owned_stonksid_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.games_owned
    ADD CONSTRAINT games_owned_stonksid_fkey FOREIGN KEY (stonksid) REFERENCES public.users(stonksid) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.games_owned DROP CONSTRAINT games_owned_stonksid_fkey;
       public          postgres    false    2905    208    207            k           2606    17217    playtime playtime_gameid_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.playtime
    ADD CONSTRAINT playtime_gameid_fkey FOREIGN KEY (gameid) REFERENCES public.games(gameid) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.playtime DROP CONSTRAINT playtime_gameid_fkey;
       public          postgres    false    2901    210    204            j           2606    17212    playtime playtime_stonksid_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.playtime
    ADD CONSTRAINT playtime_stonksid_fkey FOREIGN KEY (stonksid) REFERENCES public.users(stonksid) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.playtime DROP CONSTRAINT playtime_stonksid_fkey;
       public          postgres    false    207    2905    210            ?   ?   x?̽
?0???O?'???i)?q\B0??-M?>??????|
*!;1?<?O?Y?T???????:??ƻI?*j?='1??E?Ԣ?kV?I?eq????ޓI➲???.P??㱾ND?k?$|      ?   ?   x?m??j?@?g?)4u)?؄?NIi??K?.????\u?t)??{i!?A7?}???jX;?G|?w+US6l޺??W????'wS+x?B.a?qY??I;?V>3???ˈ?*?]?Ԏ???=???A;???e҄?wܟ??z??Ț??`4?B_|??:?J!O??r?G?H???c?p?!????\t<??O?̺\????(?1?^?      ?   ?   x?mα?0??}??\L???hb??????"?MKh5??%&?B\??ￓRD"e???s,ࢭ?rԣ?.xp5?}"b?Au7݅?W	????Vـ?T|??)??H???4??yz?????E3ڊl?????	U:[A?=>M >??????6m%?Ԓ?z?'?"?іmXֺM??/?Ճo??.@?????s?bu6      ?   ?   x?U??n?0E??W??_ġKҪ??ED?vӍ?Jmd?"_?Z?ʻ9??z?????g?E8U
x<E??%?\??åG?a½GO?J?FQw3ג#vh?	@sJWA»??6 K?????z??{2uvP?l?1@ ۪???V*6???	ڶz??2??Jx~LΒ?WBr????;6?$??u?????ny?ۤ????x3>?Q?????t?^c?L??q8??c????<˲??]?      ?   u   x?E?A? ??1[ ?????X1BN?5?:??įp	F[g?h??\q臕w?o???X?#R?%V?]^??{?`?K??҄?7W?#>?
!"ol?y?(??7aw???????UO-?      ?   8   x?3????/I-?2?
p?2???wr?2???-?I,?/?2???K?L?????? ?C?      ?   q   x?=??1?C0.1\?\???B?n?R?&t??EXsA9[-?S
???????D]6?Mks??
[?.?T?|b-k??_Q%?N???????#?^?qp??e?????Bx(?      ?   ^   x?3?t?IM.)???LVp,*)?2?tvQ(??J?.QJM?2?I?KN?+?2???/QpO?M-?2???LN??,?Q??K??2??%r??qqq ???      ?   ?   x??K
?0F???????t?t$?6jl?@Ҁ˷uz?G%$f??͵,>???訵J?!??O?$7lP????	?F?XG???[?8??W??[?,e??ΩP?J4?_?Al??)ďcH%??????t}???_?{"?p-?     