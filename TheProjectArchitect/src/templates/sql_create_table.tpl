[% PROCESS copyright.sql.include %]

[% tablename = spec.uniq.tablename %]DROP TABLE [% tablename %];

CREATE TABLE [% tablename %] (
[% FOREACH attr = entries %]	[% attr.uniq.sqlfield %] [% attr.sqltype %][% UNLESS loop.last %],
[% END %][% END %]

);
