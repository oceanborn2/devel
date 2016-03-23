[% PROCESS copyright.sql.include %]

[% tablename = spec.uniq.tablename %]
INSERT INTO [% tablename %]
([% FOREACH attr = entries %][% attr.uniq.sqlfield %][% UNLESS loop.last %],[% END %][% END %])
values ([% FOREACH attr = entries %]'?'[% UNLESS loop.last %],[% END %][% END %]);
