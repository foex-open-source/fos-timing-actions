

prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2019.10.04'
,p_release=>'19.2.0.00.18'
,p_default_workspace_id=>1620873114056663
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'FOS_MASTER_WS'
);
end;
/

prompt APPLICATION 102 - FOS Dev - Plugin Master
--
-- Application Export:
--   Application:     102
--   Name:            FOS Dev - Plugin Master
--   Exported By:     FOS_MASTER_WS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 61118001090994374
--     PLUGIN: 134108205512926532
--     PLUGIN: 168413046168897010
--     PLUGIN: 13235263798301758
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 34175298479606152
--     PLUGIN: 35822631205839510
--     PLUGIN: 2674568769566617
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
--     PLUGIN: 284978227819945411
--     PLUGIN: 56714461465893111
--   Manifest End
--   Version:         19.2.0.00.18
--   Instance ID:     250144500186934
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_fos_timing_actions
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(2600618193722136)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.FOS.TIMING_ACTIONS'
,p_display_name=>'FOS - Timing Actions'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_javascript_file_urls=>'#PLUGIN_FILES#js/script#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- =============================================================================',
'--',
'--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)',
'--',
'--  A set of actions which handle the timing of remaining actions within a ',
'--  Dynamic Action such as debounce, delay or throttle, as well an action to ',
'--  set up a timer.',
'--',
'--  License: MIT',
'--',
'--  GitHub: https://github.com/foex-open-source/fos-timing-actions',
'--',
'-- =============================================================================',
'',
'function render',
'  ( p_dynamic_action apex_plugin.t_dynamic_action',
'  , p_plugin         apex_plugin.t_plugin',
'  )',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'    l_result apex_plugin.t_dynamic_action_render_result;',
'',
'    -- general attributes',
'    l_da_id            p_dynamic_action.id%type           := p_dynamic_action.id;',
'    l_action           p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    -- debounce, delay, throttle',
'    l_delay            number                             := p_dynamic_action.attribute_02;',
'    -- debounce',
'    l_fire_immediately boolean                            := p_dynamic_action.attribute_03 = ''Y'';',
'    -- add timer, remove timer',
'    l_timer_name       p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;',
'    -- add Timer',
'    l_interval         number                             := p_dynamic_action.attribute_05;',
'    l_repeat           p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;',
'    l_repetitions      number                             := p_dynamic_action.attribute_07;',
'begin',
'',
'    --debug',
'    if apex_application.g_debug ',
'    then',
'        apex_plugin_util.debug_dynamic_action',
'            ( p_dynamic_action => p_dynamic_action',
'            , p_plugin         => p_plugin',
'            );',
'    end if;',
'',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    ',
'    case l_action',
'        when ''debounce'' then',
'            apex_json.write(''actionType''     , ''debounce'');',
'            apex_json.write(''daId''           , ''DEBOUNCE''||l_da_id);',
'            apex_json.write(''delay''          , l_delay);',
'            apex_json.write(''fireImmediately'', l_fire_immediately);',
'        when ''delay'' then',
'            apex_json.write(''actionType''     , ''delay'');',
'            apex_json.write(''delay''          , l_delay);',
'        when ''throttle'' then',
'            apex_json.write(''actionType''     , ''throttle'');    ',
'            apex_json.write(''daId''           , ''THROTTLE''||l_da_id);',
'            apex_json.write(''delay''          , l_delay);        ',
'        when ''add-timer'' then',
'            apex_json.write(''actionType''     , ''addTimer'');',
'            apex_json.write(''timerName''      , l_timer_name);',
'            apex_json.write(''interval''       , l_interval);',
'            if l_repeat != ''infinite'' then',
'                apex_json.write(''repetitions'', l_repetitions);',
'            end if;',
'        when ''remove-timer'' then',
'            apex_json.write(''actionType''     , ''removeTimer'');',
'            apex_json.write(''timerName''      , l_timer_name);',
'    end case;',
'',
'    apex_json.close_object;',
'',
'    l_result.javascript_function := ''function(){FOS.timing.action(this, '' || apex_json.get_clob_output || '');}'';',
'',
'    apex_json.free_output;',
'    return l_result;',
'end render;',
''))
,p_api_version=>2
,p_render_function=>'render'
,p_standard_attributes=>'ITEM:BUTTON:REGION:JQUERY_SELECTOR:JAVASCRIPT_EXPRESSION:TRIGGERING_ELEMENT:EVENT_SOURCE:WAIT_FOR_RESULT'
,p_substitute_attributes=>false
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'    The <strong>FOS - Timing Actions</strong> dynamic action plug-in is our solution for controling the timing and frequency of the actions contained within a Dynamic Action such as debounce, delay or throttle. It also includes a Timer to automate th'
||'e repetition of your dynamic actions. ',
'</p>',
'<h3>Delay Action</h3>',
'<p>Delays the execution of proceeding actions (i.e. higher sequenced) within your dynamic action based on the number of milliseconds provided. </p>',
'<h3>Debounce Action</h3>',
'<p>Debounces the execution of the of proceeding actions (i.e. higher sequenced) within a dynamic action. This means that you can ensure that when a dynamic action fires in quick succession it will not run the proceeding actions until X many milliseco'
||'nds (which you define) from the last call has elapsed. You have the option of immediately executing the first call.</p>',
'<p><strong>Note:</strong> there are times where throttling makes better sense than debouncing, so please also consider using the throttle action. You can read more about debouncing and throttling <a href="https://stackoverflow.com/questions/25991367/'
||'difference-between-throttling-and-debouncing-a-function">here</a></p>',
'<h3>Throttle Action</h3>',
'<p>Throttles the execution of the proceeding actions (i.e. higher sequenced) within your dynamic action. For example: if you set this delay to 5000 milliseconds on the click event of a button that refreshes a grid, if you click the button repeatedly '
||'in quick succession the maximum you could refresh the grid is once every five seconds.</p>',
'<p><strong>Note:</strong> there are times where debouncing makes better sense than throttling, so please also consider using the debounce action instead. You can read more about throttling and debouncing <a href="https://stackoverflow.com/questions/2'
||'5991367/difference-between-throttling-and-debouncing-a-function">here</a></p>',
'<h3>Timer Action</h3>',
'<p>The timer action allows you to periodically fire other dynamic actions listening to the <i>Timer Tick</i> or <i>Timer Complete</i> events.</p>',
'<ul>',
'<li>The <i>Timer Tick</i> fires upon every repetition after the timeout interval has elapsed.</li>',
'<li>The <i>Timer Complete</i> fires only once, after the last repetition. In case of an infinite timer i.e. "no limit on repetitions" then the event <i>Timer Complete</i> never fires!</li>',
'</ul>'))
,p_version_identifier=>'20.1.1'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js'))
,p_files_version=>108
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2600897574722155)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Action'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'add-timer'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The action to be performed.</p>',
'<h3>Timing Actions Overview</h3>',
'<p>A set of actions which handle the timing of remaining actions within a Dynamic Action such as debounce, delay or throttle, as well an action to set up a timer. <strong>Note:</strong> you must enable/check/toggle the dynamic action "Wait for result'
||'" option for this plug-in to work correctly.</p>',
'<h3>Delay Action</h3>',
'<p>Delays the execution of proceeding actions (i.e. higher sequenced) within your dynamic action based on the number of milliseconds provided. </p>',
'<h3>Debounce Action</h3>',
'<p>Debounces the execution of the of proceeding actions (i.e. higher sequenced) within a dynamic action. This means that you can ensure that when a dynamic action fires in quick succession it will not run the proceeding actions until X many milliseco'
||'nds (which you define) from the last call has elapsed. You have the option of immediately executing the first call.</p>',
'<p><strong>Note:</strong> there are times where throttling makes better sense than debouncing, so please also consider using the throttle action. You can read more about debouncing and throttling <a href="https://stackoverflow.com/questions/25991367/'
||'difference-between-throttling-and-debouncing-a-function">here</a></p>',
'<h3>Throttle Action</h3>',
'<p>Throttles the execution of the proceeding actions (i.e. higher sequenced) within your dynamic action. For example: if you set this delay to 5000 milliseconds on the click event of a button that refreshes a grid, if you click the button repeatedly '
||'in quick succession the maximum you could refresh the grid is once every five seconds.</p>',
'<p><strong>Note:</strong> there are times where debouncing makes better sense than throttling, so please also consider using the debounce action instead. You can read more about throttling and debouncing <a href="https://stackoverflow.com/questions/2'
||'5991367/difference-between-throttling-and-debouncing-a-function">here</a></p>',
'<h3>Timer Action</h3>',
'<p>The timer action allows you to periodically fire other dynamic actions listening to the <i>Timer Tick</i> or <i>Timer Complete</i> events.</p>',
'<ul>',
'<li>The <i>Timer Tick</i> fires upon every repetition after the timeout interval has elapsed.</li>',
'<li>The <i>Timer Complete</i> fires only once, after the last repetition. In case of an infinite timer i.e. "no limit on repetitions" then the event <i>Timer Complete</i> never fires!</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2601218467722157)
,p_plugin_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_display_sequence=>10
,p_display_value=>'Debounce Following Actions'
,p_return_value=>'debounce'
,p_help_text=>'<p>Debounces the execution of the of proceeding actions (i.e. higher sequenced) within a dynamic action.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2601790542722158)
,p_plugin_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_display_sequence=>20
,p_display_value=>'Delay Following Actions'
,p_return_value=>'delay'
,p_help_text=>'<p>Delays the execution of proceeding actions (i.e. higher sequenced) within your dynamic action based on the number of milliseconds provided.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2602299930722158)
,p_plugin_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_display_sequence=>30
,p_display_value=>'Throttle Following Actions'
,p_return_value=>'throttle'
,p_help_text=>'<p>Throttles the execution of the proceeding actions (i.e. higher sequenced) within your dynamic action</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2602737128722158)
,p_plugin_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_display_sequence=>40
,p_display_value=>'Add Timer'
,p_return_value=>'add-timer'
,p_help_text=>'<p>Add a new timer to the page to perform an action every X many seconds for X many iterations or an infinite number of iterations</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2621768019926112)
,p_plugin_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_display_sequence=>50
,p_display_value=>'Remove Timer'
,p_return_value=>'remove-timer'
,p_help_text=>'<p>Remove a timer from the page, you will need to specify the ID/name of the timer that was given to it in the "Add Timer" action</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2635246446724219)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Delay'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'500'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'debounce,delay,throttle'
,p_help_text=>'<p>The number of milliseconds to delay the timing action.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2635949379735576)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Fire Immediately'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'debounce'
,p_help_text=>'<p>Enable this option on debounce to fire the action immediately. You would use this option in the rare case where the event is firing rapidly for an extended amount of time and you want the action to immediately happen rather than being delayed.</p>'
||'<p><b>Note:</b> if you enable this option then the following actions will be fired twice, once at the start, and then once again after the debounce delay has been exceeded.</p><p></p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2636678343741817)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Timer Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'add-timer,remove-timer'
,p_help_text=>'<p>Provide an ID/name for your timer so it can be distinguished from other timers that you (may) add to the page. You will need to use this timer ID/name when using the "Remove Timer" action.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2637399106745702)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Interval'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1000'
,p_unit=>'milliseconds'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'add-timer'
,p_help_text=>'<p>Specify the interval for the timer, it should fire every X many seconds.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2638016415751452)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Repetitions'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'infinite'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2600897574722155)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'add-timer'
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Choose the repetition type. It can either be a fixed number of repetitions or an infinite number.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2638759768752501)
,p_plugin_attribute_id=>wwv_flow_api.id(2638016415751452)
,p_display_sequence=>10
,p_display_value=>'Infinite'
,p_return_value=>'infinite'
,p_help_text=>'<p>The timer will repeatedly fire based on your interval setting and will not stop until you redirect to another page in the application.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2639505013753905)
,p_plugin_attribute_id=>wwv_flow_api.id(2638016415751452)
,p_display_sequence=>30
,p_display_value=>'Custom'
,p_return_value=>'custom'
,p_help_text=>'<p>You can provide the number of iterations the timer will fire for e.g. 10</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2640221087759450)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Number of Repetitions'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2638016415751452)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'custom'
,p_help_text=>'<p>Enter the number of iterations you want the timer to fire for e.g. 10</p>'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(2643740861834124)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_name=>'timer-complete'
,p_display_name=>'FOS - Timing Actions - Timer Complete'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(2643424017834120)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_name=>'timer-tick'
,p_display_name=>'FOS - Timing Actions - Timer Tick'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C732061706578202A2F0A0A76617220464F53203D2077696E646F772E464F53207C7C207B7D3B0A0A464F532E74696D696E67203D202866756E6374696F6E202829207B0A0A202020202F2F757365642062792061646454696D6572';
wwv_flow_api.g_varchar2_table(2) := '20616E642072656D6F766554696D65720A202020207661722074696D657273203D207B7D3B0A0A202020202F2A2A0A20202020202A20412064796E616D696320616374696F6E20746F206465636C617261746976656C7920636F6E74726F6C2074686520';
wwv_flow_api.g_varchar2_table(3) := '666972696E67206F6620666F6C6C6F77696E6720616374696F6E73206F7220706572666F726D696E670A20202020202A207265706574657469766520616374696F6E73207573696E6720612074696D65720A20202020202A0A20202020202A20406D656D';
wwv_flow_api.g_varchar2_table(4) := '6265726F6620464F532E74696D696E670A20202020202A2040706172616D207B6F626A6563747D2020206461436F6E746578742020202020202020202020202020202020202020202044796E616D696320416374696F6E20636F6E746578742061732070';
wwv_flow_api.g_varchar2_table(5) := '617373656420696E20627920415045580A20202020202A2040706172616D207B6F626A6563747D202020636F6E66696720202020202020202020202020202020202020202020202020436F6E66696775726174696F6E206F626A65637420686F6C64696E';
wwv_flow_api.g_varchar2_table(6) := '672074686520636F6E66696775726174696F6E2073657474696E67730A20202020202A2040706172616D207B737472696E677D202020636F6E6669672E616374696F6E5479706520202020202020202020202020205468652074696D696E672061637469';
wwv_flow_api.g_varchar2_table(7) := '6F6E20747970653A206465626F756E63652C2064656C61792C207468726F74746C652C2061646454696D65722C2072656D6F766554696D65720A20202020202A2040706172616D207B6E756D6265727D2020205B636F6E6669672E64656C61795D202020';
wwv_flow_api.g_varchar2_table(8) := '2020202020202020202020202020546865206E756D626572206F66206D696C6C697365636F6E647320746F2064656C617920666F6C6C6F77696E6720616374696F6E732074686973206F7074696F6E206170706C69657320746F206465626F756E63652C';
wwv_flow_api.g_varchar2_table(9) := '2064656C61792C207468726F74746C650A20202020202A2040706172616D207B737472696E677D2020205B636F6E6669672E646149645D2020202020202020202020202020202020204120756E69717565206964656E74696669657220666F7220746865';
wwv_flow_api.g_varchar2_table(10) := '2064656C61792F7468726F74746C6520616374696F6E730A20202020202A2040706172616D207B626F6F6C65616E7D20205B636F6E6669672E66697265496D6D6564696174656C795D20202020202020747275652F66616C736520746F20666972652074';
wwv_flow_api.g_varchar2_table(11) := '6865206465626F756E63656420616374696F6E7320696D6D6564696174656C790A20202020202A2040706172616D207B737472696E677D2020205B636F6E6669672E74696D65724E616D655D202020202020202020202020204120756E69717565206E61';
wwv_flow_api.g_varchar2_table(12) := '6D6520746F206964656E74696679207468652074696D65720A20202020202A2040706172616D207B6E756D6265727D2020205B636F6E6669672E696E74657276616C5D20202020202020202020202020205468652074696D652028696E206D696C6C6973';
wwv_flow_api.g_varchar2_table(13) := '65636F6E647329207468652074696D65722077696C6C2066697265207468652074696D656F7574207469636B206576656E740A20202020202A2040706172616D207B6E756D6265727D2020205B636F6E6669672E72657065746974696F6E735D20202020';
wwv_flow_api.g_varchar2_table(14) := '20202020202020546865206E756D626572206F662072657065746974696F6E73206265666F7265207468652074696D65722069732072656D6F7665642C20696620756E646566696E65642069742077696C6C20626520696E66696E6974650A2020202020';
wwv_flow_api.g_varchar2_table(15) := '2A2F0A2020202066756E6374696F6E20616374696F6E286461436F6E746578742C20636F6E66696729207B0A0A2020202020202020617065782E64656275672E696E666F2827464F53202D2054696D696E6720416374696F6E73272C20636F6E66696729';
wwv_flow_api.g_varchar2_table(16) := '3B0A0A20202020202020202F2F205265706C6163696E6720737562737469747574696E6720737472696E677320616E64206573636170696E6720746865206D6573736167650A2020202020202020696620285B276465626F756E6365272C202764656C61';
wwv_flow_api.g_varchar2_table(17) := '79272C20277468726F74746C65275D2E696E6465784F6628636F6E6669672E616374696F6E5479706529203E202D3120262620216461436F6E746578742E726573756D6543616C6C6261636B29207B0A2020202020202020202020202F2F207468726F77';
wwv_flow_api.g_varchar2_table(18) := '20616E206572726F723F0A202020202020202020202020617065782E64656275672E6572726F722827464F53202D2054696D696E6720416374696F6E73202D2073657474696E6720225761697420666F7220726573756C7422206D75737420626520746F';
wwv_flow_api.g_varchar2_table(19) := '67676C6564206F6E20666F7220616374696F6E202227202B20636F6E6669672E616374696F6E54797065202B20272227293B0A20202020202020207D0A0A202020202020202076617220726573756D6543616C6C6261636B203D206461436F6E74657874';
wwv_flow_api.g_varchar2_table(20) := '2E726573756D6543616C6C6261636B207C7C2066756E6374696F6E202829207B207D3B0A0A20202020202020207377697463682028636F6E6669672E616374696F6E5479706529207B0A2020202020202020202020206361736520276465626F756E6365';
wwv_flow_api.g_varchar2_table(21) := '273A0A20202020202020202020202020202020464F532E74696D696E672E6465626F756E6365286461436F6E746578742C20636F6E666967293B0A20202020202020202020202020202020627265616B3B0A202020202020202020202020636173652027';
wwv_flow_api.g_varchar2_table(22) := '64656C6179273A0A20202020202020202020202020202020464F532E74696D696E672E64656C6179286461436F6E746578742C20636F6E666967293B0A20202020202020202020202020202020627265616B3B0A20202020202020202020202063617365';
wwv_flow_api.g_varchar2_table(23) := '20277468726F74746C65273A0A20202020202020202020202020202020464F532E74696D696E672E7468726F74746C65286461436F6E746578742C20636F6E666967293B0A20202020202020202020202020202020627265616B3B0A2020202020202020';
wwv_flow_api.g_varchar2_table(24) := '2020202063617365202761646454696D6572273A0A20202020202020202020202020202020464F532E74696D696E672E61646454696D657228636F6E666967293B0A20202020202020202020202020202020726573756D6543616C6C6261636B28293B0A';
wwv_flow_api.g_varchar2_table(25) := '20202020202020202020202020202020627265616B3B0A20202020202020202020202063617365202772656D6F766554696D6572273A0A20202020202020202020202020202020464F532E74696D696E672E72656D6F766554696D657228293B0A202020';
wwv_flow_api.g_varchar2_table(26) := '20202020202020202020202020627265616B3B0A20202020202020207D0A202020207D0A0A2020202066756E6374696F6E2064656C6179286461436F6E746578742C20636F6E66696729207B0A20202020202020202F2F2043616C6C206F75722064656C';
wwv_flow_api.g_varchar2_table(27) := '617965642066756E6374696F6E0A202020202020202073657454696D656F75742866756E6374696F6E202829207B0A202020202020202020202020617065782E64612E726573756D65286461436F6E746578742E726573756D6543616C6C6261636B2C20';
wwv_flow_api.g_varchar2_table(28) := '66616C7365293B0A20202020202020207D2C20636F6E6669672E64656C6179293B0A202020207D0A0A2020202066756E6374696F6E206465626F756E6365286461436F6E746578742C20636F6E66696729207B0A2020202020202020766172206D65203D';
wwv_flow_api.g_varchar2_table(29) := '20746869733B0A0A202020202020202066756E6374696F6E206465626F756E6365466E2863616C6C6261636B2C207761697429207B0A202020202020202020202020766172205F74686973203D20746869733B0A0A202020202020202020202020766172';
wwv_flow_api.g_varchar2_table(30) := '2074696D656F75743B0A20202020202020202020202072657475726E2066756E6374696F6E202829207B0A20202020202020202020202020202020666F722028766172205F6C656E203D20617267756D656E74732E6C656E6774682C2061726773203D20';
wwv_flow_api.g_varchar2_table(31) := '6E6577204172726179285F6C656E292C205F6B6579203D20303B205F6B6579203C205F6C656E3B205F6B65792B2B29207B0A2020202020202020202020202020202020202020617267735B5F6B65795D203D20617267756D656E74735B5F6B65795D3B0A';
wwv_flow_api.g_varchar2_table(32) := '202020202020202020202020202020207D0A0A2020202020202020202020202020202076617220636F6E74657874203D205F746869733B0A20202020202020202020202020202020636C65617254696D656F75742874696D656F7574293B0A2020202020';
wwv_flow_api.g_varchar2_table(33) := '202020202020202020202074696D656F7574203D2073657454696D656F75742866756E6374696F6E202829207B0A202020202020202020202020202020202020202072657475726E2063616C6C6261636B2E6170706C7928636F6E746578742C20617267';
wwv_flow_api.g_varchar2_table(34) := '73293B0A202020202020202020202020202020207D2C2077616974293B0A2020202020202020202020207D3B0A20202020202020207D202F2F20696620776520646F6E277420686176652061206465626F756E63652068616E646C65720A0A0A20202020';
wwv_flow_api.g_varchar2_table(35) := '2020202069662028747970656F66206D655B636F6E6669672E646149645D20213D202266756E6374696F6E2229207B0A2020202020202020202020206D655B636F6E6669672E646149645D203D206465626F756E6365466E2866756E6374696F6E202864';
wwv_flow_api.g_varchar2_table(36) := '61436F6E7465787429207B0A202020202020202020202020202020202F2F20656E73757265206465626F756E63652066756E6374696F6E2069732072656372656174656420746F206669726520696D6D6564696174656C7920616761696E206F6E206E65';
wwv_flow_api.g_varchar2_table(37) := '78742063616C6C0A2020202020202020202020202020202069662028636F6E6669672E66697265496D6D6564696174656C7929206D655B636F6E6669672E666E49645D203D20756E646566696E65643B0A20202020202020202020202020202020617065';
wwv_flow_api.g_varchar2_table(38) := '782E64612E726573756D65286461436F6E746578742E726573756D6543616C6C6261636B2C2066616C7365293B0A2020202020202020202020207D2C20636F6E6669672E64656C6179293B0A0A20202020202020202020202069662028636F6E6669672E';
wwv_flow_api.g_varchar2_table(39) := '66697265496D6D6564696174656C7929207B0A20202020202020202020202020202020617065782E64612E726573756D65286461436F6E746578742E726573756D6543616C6C6261636B2C2066616C7365293B0A2020202020202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(40) := '2020202020207D202F2F2043616C6C206F7572206465626F756E6365642066756E6374696F6E0A0A0A20202020202020206D655B636F6E6669672E646149645D2E63616C6C286D652C206461436F6E74657874293B0A202020207D0A0A2020202066756E';
wwv_flow_api.g_varchar2_table(41) := '6374696F6E207468726F74746C65286461436F6E746578742C20636F6E66696729207B0A2020202020202020766172206D65203D20746869733B0A0A2020202020202020766172207468726F74746C65203D2066756E6374696F6E202866756E632C2077';
wwv_flow_api.g_varchar2_table(42) := '61697429207B0A20202020202020202020202076617220696E5468726F74746C653B0A20202020202020202020202072657475726E2066756E6374696F6E202829207B0A202020202020202020202020202020207661722061726773203D20617267756D';
wwv_flow_api.g_varchar2_table(43) := '656E74733B0A2020202020202020202020202020202076617220636F6E74657874203D20746869733B0A0A202020202020202020202020202020206966202821696E5468726F74746C6529207B0A20202020202020202020202020202020202020206675';
wwv_flow_api.g_varchar2_table(44) := '6E632E6170706C7928636F6E746578742C2061726773293B0A2020202020202020202020202020202020202020696E5468726F74746C65203D20747275653B0A202020202020202020202020202020202020202073657454696D656F75742866756E6374';
wwv_flow_api.g_varchar2_table(45) := '696F6E202829207B0A20202020202020202020202020202020202020202020202072657475726E20696E5468726F74746C65203D2066616C73653B0A20202020202020202020202020202020202020207D2C2077616974293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(46) := '2020202020207D0A2020202020202020202020207D3B0A20202020202020207D3B202F2F20696620776520646F6E277420686176652061207468726F74746C652068616E646C657220696E697469616C697A65206F6E650A0A0A20202020202020206966';

wwv_flow_api.g_varchar2_table(47) := '2028747970656F66206D655B636F6E6669672E646149645D20213D202266756E6374696F6E2229207B0A2020202020202020202020206D655B636F6E6669672E646149645D203D207468726F74746C652866756E6374696F6E20286461436F6E74657874';
wwv_flow_api.g_varchar2_table(48) := '29207B0A20202020202020202020202020202020617065782E64612E726573756D65286461436F6E746578742E726573756D6543616C6C6261636B2C2066616C7365293B0A2020202020202020202020207D2C20636F6E6669672E64656C6179293B0A20';
wwv_flow_api.g_varchar2_table(49) := '202020202020207D202F2F2043616C6C206F7572207468726F74746C65642066756E6374696F6E0A0A0A20202020202020206D655B636F6E6669672E646149645D2E63616C6C286D652C206461436F6E74657874293B0A202020207D0A0A202020206675';
wwv_flow_api.g_varchar2_table(50) := '6E6374696F6E2061646454696D657228636F6E66696729207B0A2020202020202020766172206E616D65203D20636F6E6669672E74696D65724E616D652C0A202020202020202020202020696E74657276616C203D20636F6E6669672E696E7465727661';
wwv_flow_api.g_varchar2_table(51) := '6C2C0A2020202020202020202020206D617852657065746974696F6E73203D20636F6E6669672E72657065746974696F6E732C0A20202020202020202020202069643B0A0A2020202020202020696620286E616D65202626206E616D6520696E2074696D';
wwv_flow_api.g_varchar2_table(52) := '65727329207B0A202020202020202020202020636C656172496E74657276616C2874696D6572735B6E616D655D2E6964293B0A202020202020202020202020617065782E64656275672E7472616365282754696D6572202227202B206E616D65202B2027';
wwv_flow_api.g_varchar2_table(53) := '2220616C726561647920657869737473202D2072657374617274696E672069742E2E2E27293B0A20202020202020207D0A0A20202020202020206964203D20736574496E74657276616C2866756E6374696F6E202829207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(54) := '207661722074203D2074696D6572735B6E616D655D3B0A0A202020202020202020202020742E72657065746974696F6E436F756E742B2B3B0A202020202020202020202020617065782E64656275672E747261636528272E2E2E2074696D657220746963';
wwv_flow_api.g_varchar2_table(55) := '6B3A2027202B20742E72657065746974696F6E436F756E74293B0A0A202020202020202020202020617065782E6A51756572792827626F647927292E74726967676572282774696D65722D7469636B272C205B7B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(56) := '20276E616D65273A206E616D652C0A202020202020202020202020202020202774696D65724E616D65273A206E616D652C0A202020202020202020202020202020202774696D6572273A20740A2020202020202020202020207D5D293B0A0A2020202020';
wwv_flow_api.g_varchar2_table(57) := '20202020202020696620286D617852657065746974696F6E7320262620742E72657065746974696F6E436F756E74203E3D20742E6D617852657065746974696F6E7329207B0A20202020202020202020202020202020617065782E6A5175657279282762';
wwv_flow_api.g_varchar2_table(58) := '6F647927292E74726967676572282774696D65722D636F6D706C657465272C205B7B0A2020202020202020202020202020202020202020276E616D65273A206E616D652C0A20202020202020202020202020202020202020202774696D65724E616D6527';
wwv_flow_api.g_varchar2_table(59) := '3A206E616D652C0A20202020202020202020202020202020202020202774696D6572273A20740A202020202020202020202020202020207D5D293B0A20202020202020202020202020202020636C656172496E74657276616C28742E6964293B0A202020';
wwv_flow_api.g_varchar2_table(60) := '2020202020202020202020202064656C6574652074696D6572735B6E616D655D3B0A2020202020202020202020207D0A20202020202020207D2C20696E74657276616C293B0A0A202020202020202074696D6572735B6E616D655D203D207B0A20202020';
wwv_flow_api.g_varchar2_table(61) := '202020202020202069643A2069642C0A2020202020202020202020206E616D653A206E616D652C0A20202020202020202020202072657065746974696F6E436F756E743A20302C0A2020202020202020202020206D617852657065746974696F6E733A20';
wwv_flow_api.g_varchar2_table(62) := '6D617852657065746974696F6E730A20202020202020207D3B0A202020207D0A0A2020202066756E6374696F6E2072656D6F766554696D65722874696D65724E616D6529207B0A20202020202020206966202874696D65724E616D6520696E2074696D65';
wwv_flow_api.g_varchar2_table(63) := '727329207B0A202020202020202020202020636C656172496E74657276616C2874696D6572735B74696D65724E616D655D2E6964293B0A20202020202020202020202064656C6574652074696D6572735B74696D65724E616D655D3B0A20202020202020';
wwv_flow_api.g_varchar2_table(64) := '207D20656C7365207B0A202020202020202020202020617065782E64656275672E7472616365282754696D6572202227202B2074696D65724E616D65202B20272220646F6573206E6F7420657869737420286F7220686173206265656E2072656D6F7665';
wwv_flow_api.g_varchar2_table(65) := '6420616C7265616479292E27293B0A20202020202020207D0A202020207D0A0A202020202F2F7075626C69632066756E6374696F6E730A2020202072657475726E207B0A2020202020202020616374696F6E3A20616374696F6E2C0A2020202020202020';
wwv_flow_api.g_varchar2_table(66) := '6465626F756E63653A206465626F756E63652C0A202020202020202064656C61793A2064656C61792C0A20202020202020207468726F74746C653A207468726F74746C652C0A202020202020202061646454696D65723A2061646454696D65722C0A2020';
wwv_flow_api.g_varchar2_table(67) := '20202020202072656D6F766554696D65723A2072656D6F766554696D65720A202020207D3B0A7D2928293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(2611309123722183)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_file_name=>'js/script.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220464F533D77696E646F772E464F537C7C7B7D3B464F532E74696D696E673D66756E6374696F6E28297B76617220653D7B7D3B72657475726E7B616374696F6E3A66756E6374696F6E28652C74297B617065782E64656275672E696E666F282246';
wwv_flow_api.g_varchar2_table(2) := '4F53202D2054696D696E6720416374696F6E73222C74292C5B226465626F756E6365222C2264656C6179222C227468726F74746C65225D2E696E6465784F6628742E616374696F6E54797065293E2D31262621652E726573756D6543616C6C6261636B26';
wwv_flow_api.g_varchar2_table(3) := '26617065782E64656275672E6572726F722827464F53202D2054696D696E6720416374696F6E73202D2073657474696E6720225761697420666F7220726573756C7422206D75737420626520746F67676C6564206F6E20666F7220616374696F6E202227';
wwv_flow_api.g_varchar2_table(4) := '2B742E616374696F6E547970652B272227293B76617220693D652E726573756D6543616C6C6261636B7C7C66756E6374696F6E28297B7D3B73776974636828742E616374696F6E54797065297B63617365226465626F756E6365223A464F532E74696D69';
wwv_flow_api.g_varchar2_table(5) := '6E672E6465626F756E636528652C74293B627265616B3B636173652264656C6179223A464F532E74696D696E672E64656C617928652C74293B627265616B3B63617365227468726F74746C65223A464F532E74696D696E672E7468726F74746C6528652C';
wwv_flow_api.g_varchar2_table(6) := '74293B627265616B3B636173652261646454696D6572223A464F532E74696D696E672E61646454696D65722874292C6928293B627265616B3B636173652272656D6F766554696D6572223A464F532E74696D696E672E72656D6F766554696D657228297D';
wwv_flow_api.g_varchar2_table(7) := '7D2C6465626F756E63653A66756E6374696F6E28652C74297B76617220693D746869733B2266756E6374696F6E22213D747970656F6620695B742E646149645D262628695B742E646149645D3D66756E6374696F6E28652C74297B76617220692C613D74';
wwv_flow_api.g_varchar2_table(8) := '6869733B72657475726E2066756E6374696F6E28297B666F722876617220723D617267756D656E74732E6C656E6774682C6E3D6E65772041727261792872292C6F3D303B6F3C723B6F2B2B296E5B6F5D3D617267756D656E74735B6F5D3B76617220643D';
wwv_flow_api.g_varchar2_table(9) := '613B636C65617254696D656F75742869292C693D73657454696D656F7574282866756E6374696F6E28297B72657475726E20652E6170706C7928642C6E297D292C74297D7D282866756E6374696F6E2865297B742E66697265496D6D6564696174656C79';
wwv_flow_api.g_varchar2_table(10) := '262628695B742E666E49645D3D766F69642030292C617065782E64612E726573756D6528652E726573756D6543616C6C6261636B2C2131297D292C742E64656C6179292C742E66697265496D6D6564696174656C792626617065782E64612E726573756D';
wwv_flow_api.g_varchar2_table(11) := '6528652E726573756D6543616C6C6261636B2C213129292C695B742E646149645D2E63616C6C28692C65297D2C64656C61793A66756E6374696F6E28652C74297B73657454696D656F7574282866756E6374696F6E28297B617065782E64612E72657375';
wwv_flow_api.g_varchar2_table(12) := '6D6528652E726573756D6543616C6C6261636B2C2131297D292C742E64656C6179297D2C7468726F74746C653A66756E6374696F6E28652C74297B76617220692C612C723B2266756E6374696F6E22213D747970656F6620746869735B742E646149645D';
wwv_flow_api.g_varchar2_table(13) := '262628746869735B742E646149645D3D28693D66756E6374696F6E2865297B617065782E64612E726573756D6528652E726573756D6543616C6C6261636B2C2131297D2C613D742E64656C61792C66756E6374696F6E28297B76617220653D617267756D';
wwv_flow_api.g_varchar2_table(14) := '656E74732C743D746869733B727C7C28692E6170706C7928742C65292C723D21302C73657454696D656F7574282866756E6374696F6E28297B72657475726E20723D21317D292C6129297D29292C746869735B742E646149645D2E63616C6C2874686973';
wwv_flow_api.g_varchar2_table(15) := '2C65297D2C61646454696D65723A66756E6374696F6E2874297B76617220692C613D742E74696D65724E616D652C723D742E696E74657276616C2C6E3D742E72657065746974696F6E733B6126266120696E2065262628636C656172496E74657276616C';
wwv_flow_api.g_varchar2_table(16) := '28655B615D2E6964292C617065782E64656275672E7472616365282754696D65722022272B612B272220616C726561647920657869737473202D2072657374617274696E672069742E2E2E2729292C693D736574496E74657276616C282866756E637469';
wwv_flow_api.g_varchar2_table(17) := '6F6E28297B76617220743D655B615D3B742E72657065746974696F6E436F756E742B2B2C617065782E64656275672E747261636528222E2E2E2074696D6572207469636B3A20222B742E72657065746974696F6E436F756E74292C617065782E6A517565';
wwv_flow_api.g_varchar2_table(18) := '72792822626F647922292E74726967676572282274696D65722D7469636B222C5B7B6E616D653A612C74696D65724E616D653A612C74696D65723A747D5D292C6E2626742E72657065746974696F6E436F756E743E3D742E6D617852657065746974696F';
wwv_flow_api.g_varchar2_table(19) := '6E73262628617065782E6A51756572792822626F647922292E74726967676572282274696D65722D636F6D706C657465222C5B7B6E616D653A612C74696D65724E616D653A612C74696D65723A747D5D292C636C656172496E74657276616C28742E6964';
wwv_flow_api.g_varchar2_table(20) := '292C64656C65746520655B615D297D292C72292C655B615D3D7B69643A692C6E616D653A612C72657065746974696F6E436F756E743A302C6D617852657065746974696F6E733A6E7D7D2C72656D6F766554696D65723A66756E6374696F6E2874297B74';
wwv_flow_api.g_varchar2_table(21) := '20696E20653F28636C656172496E74657276616C28655B745D2E6964292C64656C65746520655B745D293A617065782E64656275672E7472616365282754696D65722022272B742B272220646F6573206E6F7420657869737420286F7220686173206265';
wwv_flow_api.g_varchar2_table(22) := '656E2072656D6F76656420616C7265616479292E27297D7D7D28293B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(8731587705564803)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_file_name=>'js/script.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B22464F53222C2277696E646F77222C2274696D696E67222C2274696D657273222C22616374696F6E222C226461436F6E74657874222C';
wwv_flow_api.g_varchar2_table(2) := '22636F6E666967222C2261706578222C226465627567222C22696E666F222C22696E6465784F66222C22616374696F6E54797065222C22726573756D6543616C6C6261636B222C226572726F72222C226465626F756E6365222C2264656C6179222C2274';
wwv_flow_api.g_varchar2_table(3) := '68726F74746C65222C2261646454696D6572222C2272656D6F766554696D6572222C226D65222C2274686973222C2264614964222C2263616C6C6261636B222C2277616974222C2274696D656F7574222C225F74686973222C225F6C656E222C22617267';
wwv_flow_api.g_varchar2_table(4) := '756D656E7473222C226C656E677468222C2261726773222C224172726179222C225F6B6579222C22636F6E74657874222C22636C65617254696D656F7574222C2273657454696D656F7574222C226170706C79222C226465626F756E6365466E222C2266';
wwv_flow_api.g_varchar2_table(5) := '697265496D6D6564696174656C79222C22666E4964222C22756E646566696E6564222C226461222C22726573756D65222C2263616C6C222C2266756E63222C22696E5468726F74746C65222C226964222C226E616D65222C2274696D65724E616D65222C';
wwv_flow_api.g_varchar2_table(6) := '22696E74657276616C222C226D617852657065746974696F6E73222C2272657065746974696F6E73222C22636C656172496E74657276616C222C227472616365222C22736574496E74657276616C222C2274222C2272657065746974696F6E436F756E74';
wwv_flow_api.g_varchar2_table(7) := '222C226A5175657279222C2274726967676572222C2274696D6572225D2C226D617070696E6773223A22414145412C49414149412C4941414D432C4F41414F442C4B41414F2C4741457842412C49414149452C4F4141532C574147542C49414149432C45';
wwv_flow_api.g_varchar2_table(8) := '4141532C47412B4B622C4D41414F2C43414348432C4F412F4A4A2C5341416742432C45414157432C4741457642432C4B41414B432C4D41414D432C4B41414B2C754241417742482C47414770432C434141432C574141592C514141532C59414159492C51';
wwv_flow_api.g_varchar2_table(9) := '4141514A2C4541414F4B2C614141652C4941414D4E2C454141554F2C6742414568464C2C4B41414B432C4D41414D4B2C4D41414D2C6D4641417146502C4541414F4B2C574141612C4B414739482C49414149432C4541416942502C454141554F2C674241';
wwv_flow_api.g_varchar2_table(10) := '416B422C6141456A442C4F4141514E2C4541414F4B2C594143582C4941414B2C57414344582C49414149452C4F41414F592C53414153542C45414157432C4741432F422C4D41434A2C4941414B2C514143444E2C49414149452C4F41414F612C4D41414D';
wwv_flow_api.g_varchar2_table(11) := '562C45414157432C47414335422C4D41434A2C4941414B2C574143444E2C49414149452C4F41414F632C53414153582C45414157432C4741432F422C4D41434A2C4941414B2C574143444E2C49414149452C4F41414F652C53414153582C47414370424D';
wwv_flow_api.g_varchar2_table(12) := '2C494143412C4D41434A2C4941414B2C634143445A2C49414149452C4F41414F67422C67424171496E424A2C53417A484A2C5341416B42542C45414157432C4741437A422C49414149612C4541414B432C4B416F4271422C6D4241416E42442C45414147';
wwv_flow_api.g_varchar2_table(13) := '622C4541414F652C5141436A42462C45414147622C4541414F652C4D416E42642C5341416F42432C45414155432C47414331422C49414549432C45414641432C454141514C2C4B41475A2C4F41414F2C574143482C4941414B2C494141494D2C4541414F';
wwv_flow_api.g_varchar2_table(14) := '432C55414155432C4F414151432C4541414F2C49414149432C4D41414D4A2C4741414F4B2C4541414F2C45414147412C4541414F4C2C4541414D4B2C4941433745462C4541414B452C474141514A2C55414155492C47414733422C49414149432C454141';
wwv_flow_api.g_varchar2_table(15) := '55502C45414364512C61414161542C47414362412C45414155552C594141572C5741436A422C4F41414F5A2C45414153612C4D41414D482C45414153482C4B414368434E2C49414D57612C454141572C534141552F422C4741452F42432C4541414F2B42';
wwv_flow_api.g_varchar2_table(16) := '2C6B42414169426C422C45414147622C4541414F67432C57414151432C474143394368432C4B41414B69432C47414147432C4F41414F70432C454141554F2C6742414167422C4B414331434E2C4541414F532C4F41454E542C4541414F2B422C69424143';
wwv_flow_api.g_varchar2_table(17) := '5039422C4B41414B69432C47414147432C4F41414F70432C454141554F2C6742414167422C49414B6A444F2C45414147622C4541414F652C4D41414D71422C4B41414B76422C45414149642C494177467A42552C4D416A494A2C53414165562C45414157';
wwv_flow_api.g_varchar2_table(18) := '432C474145744234422C594141572C5741435033422C4B41414B69432C47414147432C4F41414F70432C454141554F2C6742414167422C4B414331434E2C4541414F532C5141384856432C534174464A2C5341416B42582C45414157432C4741437A422C';
wwv_flow_api.g_varchar2_table(19) := '494145794271432C4541414D70422C454143764271422C4541674273422C6D42416E42724278422C4B416D424B642C4541414F652C51416E425A442C4B416F4246642C4541414F652C4F416C425773422C45416B424D2C5341415574432C4741436A4345';
wwv_flow_api.g_varchar2_table(20) := '2C4B41414B69432C47414147432C4F41414F70432C454141554F2C6742414167422C49416E426C42572C45416F4278426A422C4541414F532C4D416C42482C574143482C49414149632C4541414F462C554143504B2C454141555A2C4B41455477422C49';
wwv_flow_api.g_varchar2_table(21) := '414344442C4541414B522C4D41414D482C45414153482C4741437042652C474141612C45414362562C594141572C574143502C4F41414F552C474141612C494143724272422C4F41624E482C4B4130424E642C4541414F652C4D41414D71422C4B413142';
wwv_flow_api.g_varchar2_table(22) := '5074422C4B4130426742662C494134447A42592C53417A444A2C5341416B42582C474143642C4941474975432C45414841432C4541414F78432C4541414F79432C55414364432C4541415731432C4541414F30432C5341436C42432C454141694233432C';
wwv_flow_api.g_varchar2_table(23) := '4541414F34432C59414778424A2C47414151412C4B41415133432C494143684267442C6341416368442C4541414F32432C4741414D442C494143334274432C4B41414B432C4D41414D34432C4D41414D2C554141594E2C4541414F2C774341477843442C';
wwv_flow_api.g_varchar2_table(24) := '4541414B512C614141592C574143622C49414149432C454141496E442C4541414F32432C47414566512C45414145432C6B4241434668442C4B41414B432C4D41414D34432C4D41414D2C6D4241417142452C45414145432C69424145784368442C4B4141';
wwv_flow_api.g_varchar2_table(25) := '4B69442C4F41414F2C51414151432C514141512C614141632C434141432C4341437643582C4B414151412C45414352432C55414161442C45414362592C4D4141534A2C4B4147544C2C4741416B424B2C45414145432C694241416D42442C454141454C2C';
wwv_flow_api.g_varchar2_table(26) := '694241437A4331432C4B41414B69442C4F41414F2C51414151432C514141512C694241416B422C434141432C4341433343582C4B414151412C45414352432C55414161442C45414362592C4D4141534A2C4B414562482C63414163472C45414145542C57';
wwv_flow_api.g_varchar2_table(27) := '41435431432C4541414F32432C4D41456E42452C4741454837432C4541414F32432C474141512C43414358442C47414149412C4541434A432C4B41414D412C4541434E532C6742414169422C4541436A424E2C6541416742412C49416F4270422F422C59';
wwv_flow_api.g_varchar2_table(28) := '4168424A2C534141714236422C47414362412C4B41416135432C4741436267442C6341416368442C4541414F34432C47414157462C5741437A4231432C4541414F34432C4941456478432C4B41414B432C4D41414D34432C4D41414D2C554141594C2C45';
wwv_flow_api.g_varchar2_table(29) := '4141592C714441374B7843222C2266696C65223A227363726970742E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(8731924879564803)
,p_plugin_id=>wwv_flow_api.id(2600618193722136)
,p_file_name=>'js/script.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done




