

create or replace package body com_fos_timing_actions
as

-- =============================================================================
--
--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)
--
--  A set of actions which handle the timing of remaining actions within a
--  Dynamic Action such as debounce, delay or throttle, as well an action to
--  set up a timer.
--
--  License: MIT
--
--  GitHub: https://github.com/foex-open-source/fos-timing-actions
--
-- =============================================================================

function render
  ( p_dynamic_action apex_plugin.t_dynamic_action
  , p_plugin         apex_plugin.t_plugin
  )
return apex_plugin.t_dynamic_action_render_result
as
    l_result apex_plugin.t_dynamic_action_render_result;

    -- general attributes
    l_da_id            p_dynamic_action.id%type           := p_dynamic_action.id;
    l_action           p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    -- debounce, delay, throttle
    l_delay            number                             := p_dynamic_action.attribute_02;
    -- debounce
    l_fire_immediately boolean                            := p_dynamic_action.attribute_03 = 'Y';
    -- add timer, remove timer
    l_timer_name       p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;
    -- add Timer
    l_interval         number                             := p_dynamic_action.attribute_05;
    l_repeat           p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;
    l_repetitions      number                             := p_dynamic_action.attribute_07;
begin

    --debug
    if apex_application.g_debug
    then
        apex_plugin_util.debug_dynamic_action
            ( p_dynamic_action => p_dynamic_action
            , p_plugin         => p_plugin
            );
    end if;

    apex_json.initialize_clob_output;
    apex_json.open_object;

    case l_action
        when 'debounce' then
            apex_json.write('actionType'     , 'debounce');
            apex_json.write('daId'           , 'DEBOUNCE'||l_da_id);
            apex_json.write('delay'          , l_delay);
            apex_json.write('fireImmediately', l_fire_immediately);
        when 'delay' then
            apex_json.write('actionType'     , 'delay');
            apex_json.write('delay'          , l_delay);
        when 'throttle' then
            apex_json.write('actionType'     , 'throttle');
            apex_json.write('daId'           , 'THROTTLE'||l_da_id);
            apex_json.write('delay'          , l_delay);
        when 'add-timer' then
            apex_json.write('actionType'     , 'addTimer');
            apex_json.write('timerName'      , l_timer_name);
            apex_json.write('interval'       , l_interval);
            if l_repeat != 'infinite' then
                apex_json.write('repetitions', l_repetitions);
            end if;
        when 'remove-timer' then
            apex_json.write('actionType'     , 'removeTimer');
            apex_json.write('timerName'      , l_timer_name);
    end case;

    apex_json.close_object;

    l_result.javascript_function := 'function(){FOS.timing.action(this, ' || apex_json.get_clob_output || ');}';

    apex_json.free_output;
    return l_result;
end render;


end;
/




